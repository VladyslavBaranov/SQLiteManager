//
//  ContentView.swift
//  PasscodeLock
//
//  Created by VladyslavMac on 31.01.2022.
//

import SwiftUI

struct PasscodeLockView: View {
    
    let grid: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "0"],
        ["", "0", "Cancel"]
    ]
	
    @State var title: String = "Enter passcode to view Database"
	@State var code: [String] = []
	
	func getImageNameFor(index: Int) -> String {
		guard code.count >= index + 1 else {
			return "circle"
		}
		return "circle.fill"
	}
    
    var body: some View {
		VStack {
			Text(title)
				.padding()
			HStack(spacing: 20) {
				ForEach(0..<6, id: \.self) { i in
					Image(systemName: getImageNameFor(index: i))
                        .foregroundColor(Color(UIColor.label))
				}
			}
			
			VStack(spacing: 15) {
				
				ForEach(0..<4, id: \.self) { i in
					HStack(spacing: 15) {
						ForEach(0..<3, id: \.self) { j in
							if displayBorder(i: i, j: j) {
								Button {
									handleDigitsButtonAction(i: i, j: j)
								} label: {
									Text(grid[i][j])
										.foregroundColor(Color(UIColor.label))
										.font(i + j == 5 ? .body : .title)
										.frame(width: 80, height: 80)
										.overlay(Circle().strokeBorder(Color(UIColor.label)))
								}
								
							} else {
								Button {
									if !code.isEmpty {
										code.removeLast()
									} else {
                                        //if !isVerifying {
                                            NotificationCenter.default.post(name: .passcodeLockToBeDismissed, object: nil)
                                       // }
                                       
									}
									
								} label: {
									Text(grid[i][j])
										.foregroundColor(Color(UIColor.label))
										.font(i + j == 5 ? .body : .title)
										.frame(width: 80, height: 80)
								}
							}
						}
					}
					
				}
			}.padding(.vertical, 40)
		}
        
    }
    
    func handleDigitsButtonAction(i: Int, j: Int) {
        if code.count < 6 {
            code.append(grid[i][j])
        }
        if code.count == 6 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                let passcode = code.joined()
                if passcode == "010618" {
                    NotificationCenter.default.post(name: .passcodeLockToBeDismissed, object: 0)
                } else {
                    withAnimation {
                        title = "Wrong passcode. Try again"
                        code.removeAll()
                    }
                }
            }
        }
    }
	
	func displayBorder(i: Int, j: Int) -> Bool {
		if i == 3 && (j == 0 || j == 2) {
			return false
		}
		return true
	}
}
