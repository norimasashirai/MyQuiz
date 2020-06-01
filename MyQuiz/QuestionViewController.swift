//
//  QuestionViewController.swift
//  MyQuiz
//
//  Created by 白井教雅 on 2020/05/31.
//  Copyright © 2020 gmail.com@norimassa39. All rights reserved.
//

import UIKit
import AudioToolbox //この行を追加

class QuestionViewController: UIViewController {
    
    var questionData:QuestionData!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answet4Button: UIButton!
        
    @IBOutlet weak var correctImageview: UIImageView!
    @IBOutlet weak var incorrectImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //初期データ設定処理。前画面で設定済みのquestionDataから値を取り出す
        questionLabel.text = "Q.\(questionData.questionNo)"
        questionTextView.text = questionData.question
        answer1Button.setTitle(questionData.answer1,
                               for: UIControl.State.normal)
        answer2Button.setTitle(questionData.answer2,
                               for: UIControl.State.normal)
        answer3Button.setTitle(questionData.answer3,
                               for: UIControl.State.normal)
        answer4Button.setTitle(questionData.answer4,
                               for: UIControl.State.normal)
    }
    
    @IBAction func tapAnswer1Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 1 //選択した答えの番号を保存する
        goNextQuestionWithAnimation()//次の問題に進む
    }
    
    @IBAction func tapAnswer2Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 2 //選択した答えの番号を保存する
        goNextQuestionWithAnimation()//次の問題に進む
    }
    
    @IBAction func tapAnswer3Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 3 //選択した答えの番号を保存する
        goNextQuestionWithAnimation()//次の問題に進む
    }
    
    @IBAction func tapAnswer4Button(_ sender: Any) {
        questionData.userChoiceAnswerNumber = 4 //選択した答えの番号を保存する
        goNextQuestionWithAnimation()//次の問題に進む
    }
    
    //次の問題にアニメーション付きで進む
    func goNextQuestionWithAnimation() {
    //正解しているか判定する
    if questionData.isCorrect() {
        //正解のアニメーションを再生しながら次の問題へ遷移する
        goNextQuestionWithCorrectAnimation()
    }else{
        //不正解のアニメーションを再生しながら次の問題へ遷移する
        goNextQuestionWithIncorrectAnimation()
    }
    }

    //次の問題に正解のアニメーション付きで遷移する
    func goNextQuestionWithCorrectAnimation() {
    //正解を伝える音を鳴らす
    AudioServicesPlayAlertSound(1025)

    //アニメーション
    UIView.animate(withDuration: 2.0, animations:{
        //アルファ値を1.0に変化させる（初期値はStoryboardで0.0に設定済み）
        self.correctImageView.alpha=1.0
        }) { (Bool) in
            self.goNextQuestion()//アニメーション完了後に次の問題に進む
        }
    }

    //次の問題に不正解のアニメーション付きで遷移する
    func goNextQuestionWithCorrectAnimation() {
        //不正解を伝える音を鳴らす
        AudioServicesPlayAlertSound(1006)

    //アニメーション
        UIView.animate(withDuration: 2.0,animations:{
            //アルファ値を1.0に変化させる（初期値はStoryboardで0.0に設定済み）
            self.incorrectImageView.alpha=1.0
        }) { (Bool) in
            self.goNextQuestion()//アニメーション完了後に次の問題に進む
    }
    }
    //次の問題へ遷移する
    func goNextQuestion() {
    //問題文の取り出し
    guard let nextQuestion = QuestionDataManager.sharedInstance.nextQuestion() else {
            //問題文がなければ結果画面へ遷移する
            //StoryboardのIdentifierに設定した値（result）を指定して
            //ViewControllerを生成する
        if let resultViewController = storyboard?.instantiateViewController
        （withIdentifier: "result")as?
        ResultViewController {
            //StoryboardのSegueを利用しない明示的な画面遷移処理
            present(resultViewController, animated: true, completion: nil)
            }
        return
    }

    //問題文がある場合は次の問題へ遷移する
    //Storyboardのidentifierに設定した値（question)を設定して
    //ViewControllerを生成する
    if let nextQuestionViewController =
        storyboard?.instantiateViewController(withIdentifier:"question")
    as? QuestionViewController{
    nextQuestionViewController.questionData = nextQuestion
    //storyboardのSegueを利用しない明示的な画面遷移処理
    present(nextQuestionViewController, animated: true,
    completion: nil)
    }
    }

}
