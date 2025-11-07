package com.hyeong.bootproject.service;

import com.hyeong.bootproject.dto.CalculatorDTO;
import com.hyeong.bootproject.entity.CalculationHistory;
import com.hyeong.bootproject.repository.CalculationHistoryRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
public class CalculatorService {

    private final CalculationHistoryRepository calculationHistoryRepository;

    @Autowired
    public CalculatorService(CalculationHistoryRepository calculationHistoryRepository) {
        this.calculationHistoryRepository = calculationHistoryRepository;
    }

    @Transactional
    public int plusTwoNumbers(CalculatorDTO calculatorDTO) {

        int result = calculatorDTO.getNum1() + calculatorDTO.getNum2();
        CalculationHistory history =
                new CalculationHistory(calculatorDTO.getNum1(), calculatorDTO.getNum2(), result);
        calculationHistoryRepository.save(history);
        calculatorDTO.setSum(result);
        log.info("계산 이력 저장 완료: {}", history);

        // 정렬 query, order CreatedA by desc

        return result;
    }


    public List<CalculationHistory> getAllHistory() {
        return calculationHistoryRepository.findAllByOrderByCreatedAtDesc();
    }
}
