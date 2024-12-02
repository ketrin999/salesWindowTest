//
//  ViewController.swift
//  salesWindowTest
//
//  Created by Ekaterina Yashunina on 17.06.2024.
//

import UIKit

class GradientView: UIView {
    let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        let blackColor = UIColor.black.cgColor
        let darkGrayColor = UIColor.darkGray.darker(by: 30)?.cgColor ?? UIColor.darkGray.cgColor
        let purpleColor = UIColor.purple.darker(by: 30)?.cgColor ?? UIColor.purple.cgColor

        gradientLayer.colors = [blackColor, darkGrayColor, purpleColor]
        gradientLayer.locations = [0.0, 0.7, 1.0] // 70% для черного и темно-серого, 30% для фиолетового
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.1) // Смещаем угол наклона
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.9)
        gradientLayer.cornerRadius = 10
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

extension UIColor {
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: max(red + percentage/100, 0.0),
                           green: max(green + percentage/100, 0.0),
                           blue: max(blue + percentage/100, 0.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

class ModalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupModalView()

        // Добавление жеста для закрытия модального окна при нажатии мимо него
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }

    func setupModalView() {
        // Настройка фона модального окна
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        // Создание контейнера для модального окна
        let modalView = GradientView()
        modalView.layer.cornerRadius = 10
        modalView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modalView)

        // Создание картинки над заголовком
        let topImageView = UIImageView(image: UIImage(named: "news"))
        topImageView.contentMode = .scaleAspectFit
        topImageView.translatesAutoresizingMaskIntoConstraints = false

        // Создание заголовка
        let titleLabel = UILabel()
        titleLabel.text = "Заголовок"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Создание картинки под заголовком
        let imageView = UIImageView(image: UIImage(named: "IMG_6783"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Создание текста
        let messageLabel = UILabel()
        messageLabel.text = "Описание"
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        // Создание кнопки действия
        let actionButton = UIButton(type: .system)
        actionButton.setTitle("Вперед!", for: .normal)
        actionButton.tintColor = .black
        actionButton.backgroundColor = .systemPurple
        actionButton.layer.cornerRadius = 10
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        // Создание кнопки закрытия
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage.init(systemName: "xmark.circle"), for: .normal)
        closeButton.tintColor = .systemPurple
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // Создание стека
        let stackView = UIStackView(arrangedSubviews: [topImageView, titleLabel, imageView, messageLabel, actionButton, closeButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        modalView.addSubview(stackView)

        // Настройка ограничений (constraints)
        NSLayoutConstraint.activate([
            // Ограничения для модального окна
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.widthAnchor.constraint(equalToConstant: 300),
            modalView.heightAnchor.constraint(equalToConstant: 500),

            // Ограничения для стека
            stackView.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: modalView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20)
        ])

        // Ограничения для картинок
        NSLayoutConstraint.activate([
            topImageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc func handleTapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if let modalView = view.subviews.first(where: { $0.layer.cornerRadius == 10 }), !modalView.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func actionButtonTapped() {
        // Действие для кнопки
        print("Кнопка действия нажата")
    }

    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
}

// Пример использования ModalViewController
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let showModalButton = UIButton(type: .system)
        showModalButton.setTitle("Показать Модальное Окно", for: .normal)
        showModalButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        showModalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showModalButton)

        NSLayoutConstraint.activate([
            showModalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showModalButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func showModal() {
        let modalVC = ModalViewController()
        modalVC.modalPresentationStyle = .overFullScreen
        present(modalVC, animated: true, completion: nil)
    }
}
