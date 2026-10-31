"""630'luk büküm makinesi için cambaz yay seçimi hesapları."""

from dataclasses import dataclass
from math import floor


@dataclass(frozen=True)
class CalculationResult:
    cross_section_mm2: float
    tension_coefficient_n_per_mm2: float
    winding_tension_n: float
    spring_number: int | None
    spring_dimensions: str | None
    warning: str | None


# Tablodaki kesite eşit veya kesitten küçük en büyük referans satır kullanılır.
TENSION_COEFFICIENTS = (
    (0.09, 50.0),
    (0.14, 40.0),
    (0.35, 40.0),
    (0.80, 30.0),
    (1.50, 25.0),
    (2.50, 20.0),
    (4.00, 20.0),
    (6.00, 16.0),
)

# Makine üzerindeki eğitim kartında 3,14 kullanılıyor.
MACHINE_PI = 3.14

SPRINGS = (
    (4.0, 10.0, 1, "Ø0,8 × Ø8,80 × 55,5 mm"),
    (10.0, 80.0, 2, "Ø1,25 × Ø13,70 × 65,2 mm"),
    (80.0, 100.0, 3, "Ø1,60 × Ø12,7 × 68,0 mm"),
)


def calculate_spring(wire_count: int, single_wire_diameter_mm: float) -> CalculationResult:
    """Tel sayısı ve tek tel çapından sarım gerilimi ile yay önerisi döndürür."""
    if wire_count <= 0:
        raise ValueError("Tel sayısı sıfırdan büyük olmalıdır.")
    if single_wire_diameter_mm <= 0:
        raise ValueError("Tek tel çapı sıfırdan büyük olmalıdır.")

    raw_cross_section = wire_count * (single_wire_diameter_mm**2) * MACHINE_PI / 4
    # Karttaki örnekte önce kesit iki haneye (1,55) indirgeniyor, sonra gerilim hesaplanıyor.
    # Çok küçük ek, kayan nokta gösteriminden doğan 0,199999... türü hataları önler.
    cross_section = floor((raw_cross_section + 1e-9) * 100) / 100
    coefficient = _coefficient_for(cross_section)
    tension = cross_section * coefficient
    spring = _spring_for(tension)

    if spring is None:
        return CalculationResult(
            cross_section, coefficient, tension, None, None,
            "Sarım gerilimi 4–100 N aralığında değil. Lütfen sorumluya danışın.",
        )

    _, _, number, dimensions = spring
    return CalculationResult(cross_section, coefficient, tension, number, dimensions, None)


def _coefficient_for(cross_section_mm2: float) -> float:
    eligible = [row for row in TENSION_COEFFICIENTS if row[0] <= cross_section_mm2]
    # Tablonun altındaki değerler için ilk satırdaki katsayı kullanılır.
    return eligible[-1][1] if eligible else TENSION_COEFFICIENTS[0][1]


def _spring_for(tension_n: float) -> tuple[float, float, int, str] | None:
    for minimum, maximum, number, dimensions in SPRINGS:
        # 10 N Yay 2'ye, 80 N Yay 3'e dahil edilir.
        if minimum <= tension_n < maximum or (number == 3 and tension_n == maximum):
            return minimum, maximum, number, dimensions
    return None
