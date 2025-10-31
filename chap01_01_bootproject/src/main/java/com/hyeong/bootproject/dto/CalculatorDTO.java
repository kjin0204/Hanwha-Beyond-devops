package com.hyeong.bootproject.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@RequiredArgsConstructor
public class CalculatorDTO {
    @NonNull
    private Integer num1;
    @NonNull
    private Integer num2;
    private int sum = 0;
}
