//
//  PinTableController.swift
//  
//
//  Created by Raul Camargo on 4/3/23.
//

import Fluent
import Vapor
import FluentPostGIS

struct PinTableController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let pin = routes.grouped("pin")
        pin.get(use: index)
        pin.get(":userID", ":distance", use: pinsAroundMe)
        pin.post(use: create)
    }
    
    // Returns all pins in db. BaseURL/pin
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
                        time_confirmed: pin.timeConfirmed!)
        }
        return response
    }
    
    // Returns all pins within distance specified. BaseURL/pin/userID/distance
    func pinsAroundMe(req: Request) async throws -> [PinReturn]
    {
        let radius = req.parameters.get("distance", as: Double.self) ?? 1000
        
        let identifier = req.parameters.get("userID")!
        let user = try await User.find(identifier, on: req.db)
        let userLoc = user!.location
            
        let pins =  try await Pin.query(on: req.db)
                .filterGeographyDistanceWithin(\.$pinLocation, userLoc, radius)
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
                        time_confirmed: pin.timeConfirmed!)
        }
        return response
    }
    
    // Creates pin. BaseURL/pin
    func create(req: Request) async throws -> HTTPStatus
    {
        let newPin = try req.content.decode(PinTablePatch.self)
        let geoPT = GeographicPoint2D(longitude: newPin.longitude, latitude: newPin.latitude)
        let pin = Pin(
            userID: newPin.userID,
            confirmed: newPin.confirmed,
            pinLocation: geoPT)
        try await pin.save(on: req.db)
        return .ok
    }
}
