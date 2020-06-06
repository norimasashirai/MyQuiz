//
//  QuestionDataManager.swift
//  MyQuiz
//
//  Created by 白井教雅 on 2020/05/31.
//  Copyright © 2020 gmail.com@norimassa39. All rights reserved.
//

import Foundation

class QuestionData {
    //問題文
    var question: String
    //選択肢1
    var answer1: String
    //選択肢2
    var answer2: String
    //選択肢3
    var answer3: String
    //選択肢4
    var answer4: String
    //正解の番号
    var correctAnswerNumber: Int
    //ユーザーが選択した選択肢の番号
    var userChoiceAnswerNumber: Int?
    //問題文の番号
    var questionNo: Int = 0
    
    //クラスが生成されたときの処理
    init(questionSourceDataArray: [String]) {
        question = questionSourceDataArray[0]
        answer1 = questionSourceDataArray[1]
        answer2 = questionSourceDataArray[2]
        answer3 = questionSourceDataArray[3]
        answer4 = questionSourceDataArray[4]
        correctAnswerNumber = Int(questionSourceDataArray[5])!
    }
    //ユーザーが選択した答えが正解かどうか判定する
    func isCorrect() -> Bool {
        //答えが一致しているかどうか判定する
        if correctAnswerNumber == userChoiceAnswerNumber {
            //正解
            return true

        }
    //不正解
    return false
    }
}

class QuestionDataManager {
    static let sharedInstance = QuestionDataManager()
    var questionDataArray = [QuestionData]()
    var nowQuestionIndex: Int = 0
    //初期化処理
    private init() {
    //シングルトンであることを保証するためにprivateで宣言しておく
    }
    func loadQuestion() {
        //格納済みの問題文があればいったん削除しておく
        questionDataArray.removeAll()
        //現在の問題のインデックスを初期化
        nowQuestionIndex = 0
        //csvファイルパスを取得
        guard let csvFilePath = Bundle.main.path(forResource: "question",
        ofType:"csv") else {
        //csvファイルなし
        print("csvファイルが存在しません")
        return
        }
      //csvファイル読み込み
        do {
            let csvStringData = try String(contentsOfFile: csvFilePath,
            encoding: String.Encoding.utf8)
            //csvデータを1行ずつ読み込む
            csvStringData.enumerateLines(invoking: { (line,stop) in
            //カンマ区切りで分割
            let questionSourceDataArray =
            line.components(separatedBy:",")
            //問題データを格納するオブジェクトを作成
            let questionData=QuestionData(questionSourceDataArray:questionSourceDataArray)
            //問題を追加
            self.questionDataArray.append(questionData)
            //問題番号を設定
            questionData.questionNo=self.questionDataArray.count
            })
        } catch let error {
            print("csvファイル読み込みエラーが発生しました:\(error)")
            return
        }
    }
    //次の問題を取り出す
    func nextQuestion() -> QuestionData? {
        if nowQuestionIndex < questionDataArray.count {
    let nextQuestion = questionDataArray[nowQuestionIndex]
            nowQuestionIndex += 1
            return nextQuestion
        }
        return nil
    }
}
