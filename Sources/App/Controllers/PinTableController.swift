//
//  PinTableController.swift
//  
//
//  Created by Raul Camargo on 4/3/23.
//

import Fluent
import Vapor
import Foundation
import FluentPostGIS

struct PinTableController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let pin = routes.grouped("pin")
        pin.get(use: index)
        pin.get(":userID", ":distance", ":minutes", use: pinsAroundMe)
        pin.get("UserPinCount", ":userID", use: myTotalPinCount)
        pin.post(use: create)
        pin.put(":id", use: update)
        pin.delete("deleteAll", use: deleteAll)
    }
    
    // GET // Returns all pins in db. BaseURL/pin
    func index(req: Request) async throws -> [PinReturn]
    {
        let pins = try await Pin.query(on: req.db).all()
        let response = pins.map
        {
            pin in
                    return PinReturn(
                        id: pin.id!,
                        userID: pin.$userID.id,
                        confirmed: pin.confirmed,
                        longitude: pin.pinLocation.longitude,
                        latitude: pin.pinLocation.latitude,
                        time_created: pin.timeCreateed!,
                        time_confirmed: pin.timeConfirmed!,
                        // Added 20230503 migration
                        report: pin.report,
                        report_detail: pin.reportDetail,
                        report_location: pin.reportLocation)
        }
        return response
    }
    
    // GET // Returns all pins within distance specified. BaseURL/pin/{userID}/{distance}
    func pinsAroundMe(req: Request) async throws -> [PinReturn]
    {
        let identifier = req.parameters.get("userID")!
        let radius = req.parameters.get("distance", as: Double.self) ?? 1000
        let age = req.parameters.get("minutes", as: Double.self) ?? 60
        let cutoffTime = Date().addingTimeInterval(-(age * 60)) // Converts parameter to seconds
        
        let user = try await User.find(identifier, on: req.db)
        let userLoc = user!.location
            
        let pins =  try await Pin.query(on: req.db)
                .filterGeographyDistanceWithin(\.$pinLocation, userLoc, radius)
                .filter(\.$timeConfirmed, .greaterThanOrEqual, cutoffTime)
                .all()
        let response = pins.map
        {
            pin in
                    return PinReturn(
                        id: pin.id!,
                        userID: pin.$userID.id,
                        confirmed: pin.confirmed,
                        longitude: pin.pinLocation.longitude,
                        latitude: pin.pinLocation.latitude,
                        time_created: pin.timeCreateed!,
                        time_confirmed: pin.timeConfirmed!,
                        // Added 20230503 migration
                        report: pin.report,
                        report_detail: pin.reportDetail,
                        report_location: pin.reportLocation)
        }
        return response
    }
    
    // GET // Returns number of pins created by user. BaseURL/comment/pinsCreatedbyUser/{userID}
    func myTotalPinCount(req: Request) async throws -> Int
    {
        let identifier = req.parameters.get("userID")!
        
        let numberOfPins =  try await Pin.query(on: req.db)
            .filter(\.$userID.$id == identifier)
            .all()
                
        return numberOfPins.count
    }
    
    // POST // Creates pin. BaseURL/pin
    func create(req: Request) async throws -> HTTPStatus
    {
        let newPin = try req.content.decode(PinTablePatch.self)
        let geoPT = GeographicPoint2D(longitude: newPin.longitude, latitude: newPin.latitude)
        let pin = Pin(
            userID: newPin.userID,
            confirmed: newPin.confirmed,
            pinLocation: geoPT,
            // Added 20230503 migration
            report: newPin.report,
            reportDetail: newPin.report_detail,
            reportLocation: newPin.report_location)
        try await pin.save(on: req.db)
        return .ok
    }
    
    // PUT // Updates pin confirmation status. BaseURL/pin/{id}
    func update(req: Request) async throws -> HTTPStatus
    {
        let pin = try req.content.decode(PinTablePatch.self)
        if let identifier = req.parameters.get("id"),
        let pinID = UUID(uuidString: identifier)
        {
            // Find pin in db
            guard let dbPinEntry = try await Pin.find(pinID, on: req.db)
            else
            {
                throw Abort(.notFound)
            }
            // Update confirmed status and time
            dbPinEntry.confirmed = pin.confirmed
            try await dbPinEntry.update(on: req.db)
        }
        
        return .ok
        
    } // End update
    
    // DELETE // Deletes ALL pins in table. BaseURL/pin/deleteAll This will also clear the comment table.
    func deleteAll(req: Request) async throws -> HTTPStatus
    {
        try await Pin.query(on: req.db).all().delete(on: req.db)
        return .ok
    }
}
