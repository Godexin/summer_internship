from kivy.app import App
from kivy.lang import Builder
from kivy.properties import StringProperty
from kivy.uix.boxlayout import BoxLayout

from calculator import calculate_spring


KV = """
#:import dp kivy.metrics.dp

<ResultCard@BoxLayout>:
    orientation: "vertical"
    padding: dp(18)
    spacing: dp(8)
    size_hint_y: None
    height: dp(112)
    canvas.before:
        Color:
            rgba: (0.08, 0.18, 0.31, 1)
        RoundedRectangle:
            pos: self.pos
            size: self.size
            radius: [dp(14)]

<MainScreen>:
    orientation: "vertical"
    padding: dp(20)
    spacing: dp(14)
    canvas.before:
        Color:
            rgba: (0.96, 0.97, 0.98, 1)
        Rectangle:
            pos: self.pos
            size: self.size

    Label:
        text: "CAMBAZ YAY SEÇİMİ"
        color: (0.07, 0.16, 0.27, 1)
        bold: True
        font_size: "24sp"
        size_hint_y: None
        height: dp(38)
    Label:
        text: "630'luk büküm makineleri"
        color: (0.30, 0.35, 0.42, 1)
        font_size: "15sp"
        size_hint_y: None
        height: dp(22)

    Label:
        text: "Tel sayısı"
        color: (0.08, 0.12, 0.17, 1)
        bold: True
        size_hint_y: None
        height: dp(22)
    TextInput:
        id: wire_count
        hint_text: "Örnek: 22"
        input_filter: "int"
        multiline: False
        font_size: "20sp"
        size_hint_y: None
        height: dp(54)

    Label:
        text: "Tek tel çapı (mm)"
        color: (0.08, 0.12, 0.17, 1)
        bold: True
        size_hint_y: None
        height: dp(22)
    TextInput:
        id: wire_diameter
        hint_text: "Örnek: 0,30"
        input_filter: None
        multiline: False
        font_size: "20sp"
        size_hint_y: None
        height: dp(54)

    Button:
        text: "HESAPLA VE YAYI GÖSTER"
        background_normal: ""
        background_color: (0.00, 0.45, 0.70, 1)
        bold: True
        font_size: "17sp"
        size_hint_y: None
        height: dp(58)
        on_release: root.calculate()

    ResultCard:
        Label:
            text: root.result_title
            color: (1, 1, 1, 1)
            bold: True
            font_size: "22sp"
            halign: "center"
            text_size: self.size
        Label:
            text: root.result_detail
            color: (0.89, 0.93, 0.98, 1)
            font_size: "15sp"
            halign: "center"
            text_size: self.size

    Label:
        text: root.result_values
        color: (0.15, 0.20, 0.26, 1)
        font_size: "16sp"
        halign: "center"
        valign: "middle"
        text_size: self.size
"""


class MainScreen(BoxLayout):
    result_title = StringProperty("Değerleri girip hesaplayın")
    result_detail = StringProperty("Uygulama uygun cambaz yayını gösterecek.")
    result_values = StringProperty("")

    def calculate(self):
        try:
            wire_count = int(self.ids.wire_count.text)
            # Türkçe ondalık virgülünü de kabul eder.
            diameter = float(self.ids.wire_diameter.text.replace(",", "."))
            result = calculate_spring(wire_count, diameter)
        except (ValueError, AttributeError):
            self.result_title = "Geçerli değer giriniz"
            self.result_detail = "Tel sayısı ve tek tel çapı sıfırdan büyük olmalıdır."
            self.result_values = ""
            return

        self.result_values = (
            f"Ürün kesiti: {result.cross_section_mm2:.2f} mm²\n"
            f"Sarım gerilimi: {result.winding_tension_n:.2f} N\n"
            f"Katsayı: {result.tension_coefficient_n_per_mm2:.0f} N/mm²"
        )
        if result.warning:
            self.result_title = "Yay önerisi yok"
            self.result_detail = result.warning
        else:
            self.result_title = f"YAY NO {result.spring_number} KULLANIN"
            self.result_detail = f"Yay ölçüsü: {result.spring_dimensions}"


class CambazYayApp(App):
    title = "Cambaz Yay Seçimi"

    def build(self):
        Builder.load_string(KV)
        return MainScreen()


if __name__ == "__main__":
    CambazYayApp().run()
