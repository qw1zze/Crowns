//
//  TangoBarButton.swift
//  Crowns
//
//  Created by Dmitriy Kalyakin on 23/5/25.
//

import UIKit

final class TangoBarButton: UIButton {
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        
        self.configuration = makeConfig(title: title, image: imageName)
        self.titleLabel?.font = .systemFont(ofSize: 12)
        self.tintColor = .label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConfig(title: String, image: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: image, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        config.imagePlacement = .top
        config.imagePadding = 2
        config.baseForegroundColor = .primaryCustom
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        return config
    }
}
