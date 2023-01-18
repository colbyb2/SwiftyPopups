//
//  Popups.swift
//  SwiftyPopups
//
//  Created by Colby Brown on 1/17/23.
//

import Foundation
import SwiftUI

public struct AlertBox: View {
    
    let title: String = "AlertBox"
    let description: String = "Description"
    let leftButton: String = "Left"
    let rightButton: String = "Right"
    let action1: () -> Void = {}
    let action2: () -> Void = {}
    
    public var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 18))
                .bold()
                .padding(.top, 10)
                .padding(.bottom, 20)
                .padding(.horizontal, 10)
                .fixedSize(horizontal: false, vertical: true)
            Text(description)
                .font(.system(size: 15))
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
            Divider()
            HStack(spacing: 0) {
                Button(leftButton){action1()}
                    .frame(maxWidth: .infinity)
                Divider()
                Button(rightButton){action2()}
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: 50)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 250)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
    }
}
