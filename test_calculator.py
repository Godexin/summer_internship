import unittest
from calculator import _spring_for, calculate_spring


class SpringCalculationTests(unittest.TestCase):
    def test_machine_card_example(self):
        result = calculate_spring(22, 0.30)

        self.assertEqual(result.cross_section_mm2, 1.55)
        self.assertEqual(result.tension_coefficient_n_per_mm2, 25.0)
        self.assertEqual(result.winding_tension_n, 38.75)
        self.assertEqual(result.spring_number, 2)

    def test_spring_boundaries(self):
        self.assertEqual(_spring_for(4)[2], 1)
        self.assertEqual(_spring_for(10)[2], 2)
        self.assertEqual(_spring_for(80)[2], 3)
        self.assertEqual(_spring_for(100)[2], 3)

    def test_outside_spring_range_shows_warning(self):
        result = calculate_spring(100, 1.0)
        self.assertIsNone(result.spring_number)
        self.assertIsNotNone(result.warning)

    def test_invalid_input(self):
        with self.assertRaises(ValueError):
            calculate_spring(0, 0.30)


if __name__ == "__main__":
    unittest.main()
