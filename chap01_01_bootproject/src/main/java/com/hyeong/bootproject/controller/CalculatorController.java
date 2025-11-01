package com.hyeong.bootproject.controller;

import com.hyeong.bootproject.dto.CalculatorDTO;
import com.hyeong.bootproject.service.CalculatorService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class CalculatorController {
    CalculatorService calculatorService;

    @Autowired
    public CalculatorController(CalculatorService calculatorService) {
        this.calculatorService = calculatorService;
    }

    @GetMapping("/health")
    public String healThCheck() {
        return "I'm Alive!";
    }

    @PostMapping("/plus")
    public ResponseEntity<CalculatorDTO> plusTwoNumbers (@RequestBody CalculatorDTO calculatorDTO) {
        log.info("calculatorDTO 수신={}", calculatorDTO);
        int result = calculatorService.plusTwoNumbers(calculatorDTO);
        log.info("calculatorDTO 결과={}", calculatorDTO);

        return ResponseEntity.ok().body(calculatorDTO);
    }


    @GetMapping("/plus")
    public ResponseEntity<CalculatorDTO> plusTwoNumbers2 (CalculatorDTO calculatorDTO) {
        log.info("calculatorDTO 수신={}", calculatorDTO);
        int result = calculatorService.plusTwoNumbers(calculatorDTO);
        log.info("calculatorDTO 결과={}", calculatorDTO);

        return ResponseEntity.ok().body(calculatorDTO);
    }


}
