package com.hyeong.bootproject.repository;

import com.hyeong.bootproject.entity.CalculationHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CalculationHistoryRepository extends JpaRepository<CalculationHistory,Long> {
    List<CalculationHistory> findAllByOrderByCreatedAtDesc();
}
