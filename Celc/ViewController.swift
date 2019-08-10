//
//  ViewController.swift
//  Celc
//
//  Created by Toshiki on 2016/10/24.
//  Copyright © 2016 Toshiki.Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //From here
    
    @IBOutlet weak var Status: UITextField!
    @IBOutlet weak var Monitor: UITextField!
    
    var operand1:Double = 0.0, operand2:Double = 0.0
    var opSwitch:Int = 0
    var isEnter:Bool = false
    var isEqual:Bool = false
    var point:Int = 0
    var isPoint:Bool = false
    //Plus = 1, Minus = 2, Times = 3, Devide = 4
    //Memory
    var isMemory:Bool = false
    var Memory1:Double = 0.0
    var Memory2:Double = 0.0
    
    
    func printStatus(){
        var str:String = ""
        if isMemory == true{
            str += " M "
        }else{
            str += "   "
        }
        for _ in 0 ..< opSwitch{
            str += "   "
        }
        switch opSwitch{
        case 1:
            str += " + "
        case 2:
            str += " - "
        case 3:
            str += " * "
        case 4:
            str += " / "
        default:
            break
        }
        Status.text = str
    }
    
    func printMonitor(Set num:Double, Memory m:Bool = false){
        let tmp:Double = num >= 0 ? num : -num
        var i  :Int    = Int(tmp)
        var ori:String = String(tmp)
        var out:String = ""
        
        //整数部の処理
        if i != 0{
            var com:Int = 0//Comma
            while i != 0{
                if com > 2{
                    out += ","
                    com = 0
                }
                out += String(i % 10)
                i /= 10
                com += 1
            }
        }else{
            out += "0"
        }
        if num < 0{
            out += "-"
        }
        out = String(out.characters.reversed())//反転
        
        //少数部の処理
        var end:Character?
        for i in ori.characters{
            end = i
        }
        if end != "0" || isPoint == true{
            var cnt = 0
            out += "."
            if end != "0"{
                var flg = false
                for s in ori.characters{
                    if flg == true{
                        out += String(s)
                        cnt += 1
                    }
                    if s == "."{
                        flg = true
                    }
                }
            }
            while cnt < point{
                out += "0"
                cnt += 1
            }
            
        }
        Monitor.text = out
        if m == false{
            Memory2 = num
        }
    }
    
    func enter(num:Double){
        var num = num
        if isEqual == true{
            operand1 = 0.0
            isEqual  = false
        }
        if isEnter == false{
            operand2 = 0.0
        }
        if isPoint == false{
            operand2 *= 10
        }else{
            for _ in 0 ... point{
                num /= 10
            }
            point += 1
        }
        if operand2 < 0{
            num = -num
        }
        operand2 += num
        isEnter = true
        printMonitor(Set:operand2)
    }
    
    func celc(op:Int){
        if isEqual == false && isEnter == true{
            switch opSwitch{
            case 1:
                operand1 += operand2
            case 2:
                operand1 -= operand2
            case 3:
                operand1 *= operand2
            case 4:
                if operand2 != 0{
                    operand1 /= operand2
                }else{
                    Monitor.text = "Error"
                    operand1 = 0.0
                    operand2 = 0.0
                    opSwitch = 0
                    point    = 0
                    isEnter  = false
                    isEqual  = false
                    isPoint  = false
                    printStatus()
                    return
                }
            default:
                operand1 = operand2
            }
            printMonitor(Set:operand1)
            //operand2 = 0.0
        }else{
            isEqual = false
        }
        opSwitch = op
        isEnter  = false
        point    = 0
        isPoint  = false
    }
    
    
    @IBAction func AllClear(_ sender: AnyObject) {
        operand1 = 0.0
        operand2 = 0.0
        opSwitch = 0
        point    = 0
        isEnter  = false
        isEqual  = false
        isPoint  = false
        printMonitor(Set: 0)
        printStatus ()
    }
    @IBAction func PlusOrMinus(_ sender: AnyObject) {
        if isEnter == true{
            operand2 = -operand2
            printMonitor(Set:operand2)
        }else if isEqual == true{
            operand1 = -operand1
            printMonitor(Set:operand1)
        }
    }
    @IBAction func Percent(_ sender: AnyObject) {
        if isEnter == true{
            operand2 /= 100
            point    += 2
            isPoint   = true
            printMonitor(Set:operand2)
        }
    }
    //Operators
    @IBAction func Devide(_ sender: AnyObject) {
        celc(op:4)
        printStatus()
    }
    @IBAction func Times (_ sender: AnyObject) {
        celc(op:3)
        printStatus()
    }
    @IBAction func Minus (_ sender: AnyObject) {
        celc(op:2)
        printStatus()
    }
    @IBAction func Plus  (_ sender: AnyObject) {
        celc(op:1)
        printStatus()
    }
    @IBAction func Equal (_ sender: AnyObject) {
        celc(op:0)
        printStatus()
        isEqual = true
    }
    
    //Memory
    @IBAction func MemoryClear (_ sender: AnyObject) {
        isMemory = false
        Memory1  = 0.0
        Memory2  = 0.0
        printStatus()
    }
    @IBAction func MemoryResult(_ sender: AnyObject) {
        printMonitor(Set: Memory1, Memory: true)
    }
    @IBAction func MemoryMinus (_ sender: AnyObject) {
        isMemory = true
        Memory1 -= Memory2
        printStatus()
    }
    @IBAction func MemoryPlus  (_ sender: AnyObject) {
        isMemory = true
        Memory1 += Memory2
        printStatus()
    }
    
    
    //Numbers
    @IBAction func Nine (_ sender: AnyObject) {
        enter(num:9)
    }
    @IBAction func Eight(_ sender: AnyObject) {
        enter(num:8)
    }
    @IBAction func Seven(_ sender: AnyObject) {
        enter(num:7)
    }
    @IBAction func Six  (_ sender: AnyObject) {
        enter(num:6)
    }
    @IBAction func Five (_ sender: AnyObject) {
        enter(num:5)
    }
    @IBAction func Four (_ sender: AnyObject) {
        enter(num:4)
    }
    @IBAction func Three(_ sender: AnyObject) {
        enter(num:3)
    }
    @IBAction func Two  (_ sender: AnyObject) {
        enter(num:2)
    }
    @IBAction func One  (_ sender: AnyObject) {
        enter(num:1)
    }
    @IBAction func Zero (_ sender: AnyObject) {
        enter(num:0)
    }
    @IBAction func DoubleZero(_ sender: AnyObject) {
        enter(num:0)
        enter(num:0)
    }
    @IBAction func PointButton(_ sender: AnyObject) {
        isPoint = true
        printMonitor(Set:operand2)
    }
}
