//
//  GeneratedWorkoutDTO.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/24/25.
//

struct WorkoutDTO: Decodable {
    let day: String
    let title: String
    let totalTime: String
    let totalRoutines: String
    let routines: [RoutineDTO]
    
    func toDomain() -> DailyWorkout {
        .init(routines: routines.map({ $0.toDomain() }), totalTime: totalTime, day: day, totalRoutines: totalRoutines, title: title)
    }
}
