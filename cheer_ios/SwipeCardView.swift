//
//  SwipeCardView.swift
//  cheer_ios
//
//  Created by 梶原大進 on 2019/10/12.
//  Copyright © 2019年 梶原大進. All rights reserved.
//

import UIKit

class SwipeCardView: UIView {
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cheerLabel: UILabel!
    
    // コードから生成した時の初期化処理
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibInit()
    }
    
    // ストーリーボードで配置した時の初期化処理
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibInit()
    }
    
    // xibファイルを読み込んでviewに重ねる
    fileprivate func nibInit() {
        guard let view = UINib(nibName: "SwipeCard", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = self.bounds
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(view)
    }
    
}
