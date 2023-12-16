//
//  GlobalFunctions.swift
//  MyApp
//
//  Created by SAHIL AMRUT AGASHE on 15/12/23.
//


import MapKit

func getLabelAndTextfieldVstack(labelText: String, textField: UITextField) -> UIStackView {
    let label = UILabel()
    label.text = labelText
    
    let vstack = UIStackView(arrangedSubviews: [label, textField])
    vstack.axis = .vertical
    vstack.spacing = 5
    vstack.translatesAutoresizingMaskIntoConstraints = false
    return vstack
}

func getTextField(textFieldPlaceholder: String) -> UITextField {
    let tf = UITextField()
    tf.translatesAutoresizingMaskIntoConstraints = false
    tf.placeholder = textFieldPlaceholder
    tf.borderStyle = .roundedRect
    tf.backgroundColor = .white
    tf.widthAnchor.constraint(equalToConstant: 300).isActive = true
    tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
    return tf
}

func getMKPointAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> MKPointAnnotation {
    let pointAnnotation = MKPointAnnotation()
    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    return pointAnnotation
}

func showAlerControllerMessage(title: String, message: String, presentingViewController viewController: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default)
    alertController.addAction(ok)
    viewController.present(alertController, animated: true)
}
