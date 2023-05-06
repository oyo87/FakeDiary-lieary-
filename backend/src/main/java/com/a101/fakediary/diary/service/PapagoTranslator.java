package com.a101.fakediary.diary.service;

import org.apache.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Component
public class PapagoTranslator {
  private final WebClient webClient;
  private final String papagoUrl = "https://openapi.naver.com/v1/papago/n2mt";

  public PapagoTranslator() {
    this.webClient = WebClient.builder()
        .baseUrl(papagoUrl)
        .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
        .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
        .defaultHeader("X-Naver-Client-Id", "akrwocKbrRSeXp1WeVxt")
        .defaultHeader("X-Naver-Client-Secret", "Bcoog3Yr9a")
        .build();
  }

  public Mono<String> translate(String text) {
    MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();
    formData.add("source", "ko");
    formData.add("target", "en");
    formData.add("text", text);

    return webClient.post()
        .contentType(MediaType.APPLICATION_FORM_URLENCODED)
        .body(BodyInserters.fromFormData(formData))
        .accept(MediaType.APPLICATION_JSON)
        .retrieve()
        .bodyToMono(String.class);
  }
}
