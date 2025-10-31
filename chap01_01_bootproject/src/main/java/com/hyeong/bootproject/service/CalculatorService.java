package com.hyeong.bootproject.service;

import com.hyeong.bootproject.dto.CalculatorDTO;
import org.springframework.stereotype.Service;

@Service
public class CalculatorService {
    public int plusTwoNumbers(CalculatorDTO calculatorDTO) {

        calculatorDTO.setSum(calculatorDTO.getNum1() + calculatorDTO.getNum2());
        return calculatorDTO.getNum1() + calculatorDTO.getNum2();
    }
}
