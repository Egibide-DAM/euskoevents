//
//  Evento.swift
//  EuskoEvents
//
//  Created by Ion Jaureguialzo Sarasola on 27/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import Foundation

struct Evento: Comparable {

    static func < (lhs: Evento, rhs: Evento) -> Bool {
        return lhs.fechaInicio < rhs.fechaInicio
    }

    static func == (lhs: Evento, rhs: Evento) -> Bool {
        return lhs.titulo == rhs.titulo && lhs.fechaInicio == rhs.fechaInicio
    }

    var titulo: String

    var fechaInicio: Date
    var fechaFin: Date

    var provincias: String

    var url: URL?

    var latitud: Double?
    var longitud: Double?

}
