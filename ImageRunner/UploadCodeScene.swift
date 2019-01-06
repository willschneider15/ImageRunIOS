//
//  UploadCodeScene.swift
//  ImageRunner
//
//  Created by William Schneider on 1/5/19.
//  Copyright © 2019 William Schneider. All rights reserved.
//

import UIKit

class UploadCodeScene: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var uploadCodePicker: UIPickerView!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    @IBOutlet weak var uploadCodeBox: UITextField!
    @IBOutlet weak var languageBox: UITextField!
    
    
    var uploadOptions = ["choose photo","take photo"]
    //var languageOptions = [String]()
    var languageOptions = ["javascript"]
    
    override func viewDidLoad() {
        //multi language function get the array by pinging the server
        super.viewDidLoad()
    }
    
    @IBAction func run(_ sender: Any) {
        if uploadCodeBox.text == "choose photo"{
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
            self.performSegue(withIdentifier: "uploadToOutput", sender: self)
        }
        else if uploadCodeBox.text == "take photo"{
            self.performSegue(withIdentifier: "start2Camera", sender: self)
        }
        else{
            let alertController = UIAlertController(title: "ERROR", message: "Must Fill In Parameters", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
       

        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var countRow: Int = uploadOptions.count
        if pickerView == languagePicker{
            countRow = languageOptions.count
        }
        return countRow
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == uploadCodePicker{
            let rowNum = uploadOptions[row]
            return rowNum
        }
        else if pickerView == languagePicker{
            let rowNum = languageOptions[row]
            return rowNum
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == uploadCodePicker{
            self.uploadCodeBox.text = self.uploadOptions[row]
            self.uploadCodePicker.isHidden = true
        }
        else{
            self.languageBox.text = self.languageOptions[row]
            self.languagePicker.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.uploadCodeBox{
            self.uploadCodeBox.text = self.uploadOptions[0]
            self.uploadCodePicker.isHidden = false
        }
        else if textField == self.languageBox{
            self.languageBox.text = self.languageOptions[0]
            self.languagePicker.isHidden = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData:Data = image_data!.pngData()!
        let imageStr = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}
