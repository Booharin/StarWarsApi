import Foundation


final class DescriptionBuilder {
    
    func build(from people: People) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Birth year:", value: people.birthYear ?? "unknown"))
        elements.append(.keyValue(name: "Gender:", value: people.gender ?? "unknown"))
        elements.append(.keyValue(name: "Homeworld:", value: people.homeworld?.name ?? "unknown"))
        elements.append(.keyValue(name: "Height:", value: people.height.toNonNegativeString))
        elements.append(.keyValue(name: "Mass:", value: people.mass.toNonNegativeString))
        elements.append(.keyValue(name: "Eye color:", value: people.eyeColor ?? "unknown"))
        elements.append(.keyValue(name: "Hair color:", value: people.hairColor ?? "unknown"))
        elements.append(.keyValue(name: "Skin color:", value: people.skinColor ?? "unknown"))

        if people.species?.isNotEmpty == true {
            elements.append(.group(name: "Species"))

            (people.species as? Set<Specie>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        if people.starships?.isNotEmpty == true {
            elements.append(.group(name: "Starships"))
            
            (people.starships as? Set<StarShip>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        if people.vehicles?.isNotEmpty == true {
            elements.append(.group(name: "Vehicles"))
            
            (people.vehicles as? Set<Vehicle>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from specie: Specie) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Classification:", value: specie.classification ?? "unknown"))
        elements.append(.keyValue(name: "Designation:", value: specie.designation ?? "unknown"))
        elements.append(.keyValue(name: "Homeworld:", value: specie.homeworld?.name ?? "unknown"))
        elements.append(.keyValue(name: "Language:", value: specie.language ?? "unknown"))
        elements.append(.keyValue(name: "Avg. height:", value: specie.averageHeight.toNonNegativeString))
        elements.append(.keyValue(name: "Avg. lifespan", value: specie.averageLifespan.toNonNegativeString))
        elements.append(.keyValue(name: "Eye colors:", value: specie.eyeColors ?? "unknown"))
        elements.append(.keyValue(name: "Hair colors:", value: specie.hairColors ?? "unknown"))
        elements.append(.keyValue(name: "Skin color:", value: specie.skinColors ?? "unknown"))

        
        if specie.people?.isNotEmpty == true {
            elements.append(.group(name: "Peoples"))
            
            (specie.people as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from planet: Planet) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Climate:", value: planet.climate ?? "unknown"))
        elements.append(.keyValue(name: "Terian:", value: planet.terrain ?? "unknown"))
        elements.append(.keyValue(name: "Water:", value: planet.surfaceWater.toNonNegativeString))
        elements.append(.keyValue(name: "Gravity:", value: planet.gravity ?? "unknown"))
        elements.append(.keyValue(name: "Diameter:", value: planet.diameter.toNonNegativeString))
        elements.append(.keyValue(name: "Population", value: planet.population.toNonNegativeString))
        elements.append(.keyValue(name: "Rotation:", value: planet.rotationPeriod.toNonNegativeString))
        elements.append(.keyValue(name: "Orbit:", value: planet.orbitalPeriod.toNonNegativeString))
        
        
        if planet.residents?.isNotEmpty == true {
            elements.append(.group(name: "Residents"))
            
            (planet.residents as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from starship: StarShip) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Class:", value: starship.starshipClass ?? "unknown"))
        elements.append(.keyValue(name: "Model:", value: starship.model ?? "unknown"))
        elements.append(.keyValue(name: "MGLT:", value: starship.mglt.toNonNegativeString))
        elements.append(.keyValue(name: "max ATS:", value: starship.maxAtmospheringSpeed.toNonNegativeString))
        elements.append(.keyValue(name: "Cost:", value: starship.cost.toNonNegativeString))
        elements.append(.keyValue(name: "Hyperdrive", value: starship.hyperDriveRating.toNonNegativeString))
        elements.append(.keyValue(name: "Length:", value: starship.length.toNonNegativeString))
        elements.append(.keyValue(name: "Crew:", value: starship.crew.toNonNegativeString))
        elements.append(.keyValue(name: "Passengers:", value: starship.passengers.toNonNegativeString))
        elements.append(.keyValue(name: "Cargo:", value: starship.cargoCapacity.toNonNegativeString))
        elements.append(.keyValue(name: "Manufacturer:", value: starship.manufacturer ?? "unknown"))

        
        if starship.pilots?.isNotEmpty == true {
            elements.append(.group(name: "Pilots"))
            
            (starship.pilots as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from vehicle: Vehicle) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Class:", value: vehicle.vehicleClass ?? "unknown"))
        elements.append(.keyValue(name: "Model:", value: vehicle.model ?? "unknown"))
        elements.append(.keyValue(name: "max ATS:", value: vehicle.maxAtmospheringSpeed.toNonNegativeString))
        elements.append(.keyValue(name: "Cost:", value: vehicle.cost.toNonNegativeString))
        elements.append(.keyValue(name: "Length:", value: vehicle.length.toNonNegativeString))
        elements.append(.keyValue(name: "Crew:", value: vehicle.crew.toNonNegativeString))
        elements.append(.keyValue(name: "Passengers:", value: vehicle.passengers.toNonNegativeString))
        elements.append(.keyValue(name: "Cargo:", value: vehicle.cargoCapacity.toNonNegativeString))
        elements.append(.keyValue(name: "Manufacturer:", value: vehicle.manufacturer ?? "unknown"))
        
        
        if vehicle.pilots?.isNotEmpty == true {
            elements.append(.group(name: "Pilots"))
            
            (vehicle.pilots as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
}

enum DescriptionElement {
    case group(name: String)
    case keyValue(name: String, value: String)
    case singleValue(value: String)
}
