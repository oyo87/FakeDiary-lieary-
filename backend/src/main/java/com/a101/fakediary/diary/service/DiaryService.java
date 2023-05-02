package com.a101.fakediary.diary.service;

import com.a101.fakediary.diary.dto.DiaryRequestDto;
import com.a101.fakediary.diary.dto.DiaryResponseDto;
import com.a101.fakediary.diary.entity.Diary;
import com.a101.fakediary.diary.repository.DiaryRepository;
import com.a101.fakediary.genre.dto.GenreDto;
import com.a101.fakediary.genre.repository.GenreRepository;
import com.a101.fakediary.genre.service.GenreService;
import com.a101.fakediary.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class DiaryService {

    private final DiaryRepository diaryRepository;
    private final MemberRepository memberRepository;
    private final GenreService genreService;

    public Diary toEntity(DiaryRequestDto dto) {
        return Diary.builder()
                .member(memberRepository.findByMemberId(dto.getMemberId()))
                .keyword(dto.getKeyword())
                .prompt(dto.getPrompt())
                .title(dto.getTitle())
                .detail(dto.getDetail())
                .summary(dto.getSummary())
                .build();
    }

    @Transactional
    public void saveDiary(DiaryRequestDto dto) {
        Diary diary = diaryRepository.save(toEntity(dto)); //일기 저장
        String[] s = dto.getGenre();

        for (int i = 0; i < s.length; i++) {
            GenreDto gen = new GenreDto(diary.getDiaryId(), s[i]);
            genreService.saveGenre(gen); //장르 저장
        }
    }

    @Transactional(readOnly = true)
    public DiaryResponseDto detailDiary(Long diaryId) {
        return new DiaryResponseDto(diaryRepository.findByDiaryId(diaryId));
    }

    @Transactional(readOnly = true)
    public List<DiaryResponseDto> allDiary(Long memberId) {
        return diaryRepository.allDiary(memberId);
    }

    @Transactional(readOnly = true)
    public List<DiaryResponseDto> filterDiary(Long memberId, String genre) {
        return diaryRepository.filterDiary(memberId, genre);
    }

    @Transactional(readOnly = true)
    public List<DiaryResponseDto> getDevelopersDiaries() {
        return diaryRepository.getDevelopersDiaries();
    }

    @Transactional
    public void deleteDiary(Long diaryId) {
        genreService.deleteGenre(diaryId);
        diaryRepository.deleteDiary(diaryId);
    }
}