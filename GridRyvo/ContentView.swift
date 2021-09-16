//
//  ContentView.swift
//  GridRyvo
//
//  Created by Adam Jemni on 9/16/21.
//

import SwiftUI
import ASCollectionView
import UIKit

struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    @State var data: [Post] = DataSource.postsForGridSection(1, number: 1000)
    typealias SectionID = Int
    
    // MARK: - FUNCTION
    
    func onCellEvent(_ event: CellEvent<Post>)
    {
        switch event
        {
        case let .onAppear(item):
            ASRemoteImageManager.shared.load(item.url)
        case let .onDisappear(item):
            ASRemoteImageManager.shared.cancelLoad(for: item.url)
        case let .prefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.load(item.url)
            }
        case let .cancelPrefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.cancelLoad(for: item.url)
            }
        }
    }
    
  // MARK: - SECTION
    
    var section: ASCollectionViewSection<SectionID>
    {
        ASCollectionViewSection(
            id: 0,
            data: data,
            onCellEvent: onCellEvent)
        { item, state in
            ZStack(alignment: .bottomTrailing)
            {
                GeometryReader
                { geom in
                    
                    ASRemoteImageView(item.url)
                        .aspectRatio(1, contentMode: .fill)
                        .frame(width: geom.size.width, height: geom.size.height)
                        .clipped()
                }
            }
        }
    }
    
    
    // MARK: - BODY
    
    var body: some View
    {
        ASCollectionView(
            section: section)
            .layout(self.layout)
            .edgesIgnoringSafeArea(.all)
    }
}


extension ContentView
{
    var layout: ASCollectionLayout<Int>
    {
        ASCollectionLayout(scrollDirection: .vertical, interSectionSpacing: 0)
        {
            ASCollectionLayoutSection
            { environment in
                let isWide = environment.container.effectiveContentSize.width > 500
                let gridBlockSize = environment.container.effectiveContentSize.width / (isWide ? 5 : 3)
                
                let gridBlockSizeHeight = (gridBlockSize / 9 ) * 16
                
                let gridItemInsets = NSDirectionalEdgeInsets(top: 1.5, leading: 1.5, bottom: 1.5, trailing: 1.5)
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(gridBlockSize), heightDimension: .absolute(gridBlockSizeHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = gridItemInsets
                let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(gridBlockSize), heightDimension: .absolute(gridBlockSizeHeight * 2))
                let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: item, count: 2)
                
                let featureItemSize = NSCollectionLayoutSize(widthDimension: .absolute(gridBlockSize * 2), heightDimension: .absolute(gridBlockSizeHeight * 2))
                let featureItem = NSCollectionLayoutItem(layoutSize: featureItemSize)
                featureItem.contentInsets = gridItemInsets
                
                
                let verticalAndFeatureGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(gridBlockSizeHeight * 2))
                let verticalAndFeatureGroupA = NSCollectionLayoutGroup.horizontal(layoutSize: verticalAndFeatureGroupSize, subitems: isWide ? [verticalGroup, verticalGroup, featureItem, verticalGroup] : [verticalGroup, featureItem])
                let verticalAndFeatureGroupB = NSCollectionLayoutGroup.horizontal(layoutSize: verticalAndFeatureGroupSize, subitems: isWide ? [verticalGroup, featureItem, verticalGroup, verticalGroup] : [featureItem, verticalGroup])
                
                let rowGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(gridBlockSizeHeight))
                let rowGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rowGroupSize, subitem: item, count: isWide ? 5 : 3)
                
                let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(gridBlockSizeHeight * 6))
                let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: [verticalAndFeatureGroupA, rowGroup, verticalAndFeatureGroupB, rowGroup])
                
                let section = NSCollectionLayoutSection(group: outerGroup)
                return section
            }
        }
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
