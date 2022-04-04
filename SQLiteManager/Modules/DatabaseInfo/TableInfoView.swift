//
//  TableInfoView.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 10.02.2022.
//

import SwiftUI

struct AttributeCell: View {
    @State var attribute: TableInfo.Field
    var body: some View {
        HStack {
            Text(attribute.identifier)
                .font(.monospaced(.body)())
            Spacer()
            if attribute.isPrimaryKey {
                Image(systemName: "key")
                    .foregroundColor(.yellow)
            }
            Text(attribute.type.uppercased())
                .foregroundColor(.red)
                .font(.monospaced(.body)())
        }
    }
}

struct TableInfoView: View {
    
    var tableInfo: TableInfo
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    ForEach(0..<tableInfo.fields.count, id: \.self) { i in
                        AttributeCell(attribute: tableInfo.fields[i])
                    }
                } header: {
                    Text("Attributes")
                }
                
                Section {
                    Text(tableInfo.sql)
                        .font(.monospaced(.body)())
                } header: {
                    Text("SQL query")
                }
                
                Section {
                    Text("DROP")
                        .foregroundColor(.red)
                } header: {
                    Text("Warning!")
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(tableInfo.tableName)
            
        }
        .environment(\.horizontalSizeClass, .compact)
        
        
    }
}

struct ViewTriggerIndexView: View {
    
    var entity: SingleNamedInfo
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text(entity.tableName)
                        .font(.monospaced(.body)())
                } header: {
                    Text("Associaated table")
                }
                Section {
                    Text(entity.sql)
                        .font(.monospaced(.body)())
                } header: {
                    Text("SQL query")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(entity.name)
        }
        .environment(\.horizontalSizeClass, .compact)
    }
}
