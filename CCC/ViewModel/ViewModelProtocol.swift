//
//  ViewModelProtocol.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

protocol ViewModelProtocol {
  associatedtype Action
  associatedtype State

  var action: ((Action) -> Void)? { get }
  var state: State { get }
}
