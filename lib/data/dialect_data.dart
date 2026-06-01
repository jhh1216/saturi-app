class DialectSentence {
  final String dialect;
  final String standard;

  const DialectSentence({required this.dialect, required this.standard});
}

class Region {
  final String name;
  final String emoji;
  final List<DialectSentence> sentences;

  const Region({
    required this.name,
    required this.emoji,
    required this.sentences,
  });
}

const List<Region> regions = [
  Region(
    name: '서울/표준어',
    emoji: '🏙️',
    sentences: [
      DialectSentence(dialect: '어디 가요?', standard: '어디 가요?'),
      DialectSentence(dialect: '밥 먹었어요?', standard: '밥 먹었어요?'),
      DialectSentence(dialect: '이거 뭐예요?', standard: '이거 뭐예요?'),
      DialectSentence(dialect: '잠깐만요', standard: '잠깐만요'),
      DialectSentence(dialect: '고마워요', standard: '고마워요'),
      DialectSentence(dialect: '오늘 날씨 좋네요', standard: '오늘 날씨 좋네요'),
      DialectSentence(dialect: '같이 가요', standard: '같이 가요'),
      DialectSentence(dialect: '얼마예요?', standard: '얼마예요?'),
      DialectSentence(dialect: '맛있어요', standard: '맛있어요'),
      DialectSentence(dialect: '조심하세요', standard: '조심하세요'),
      DialectSentence(dialect: '다음에 봐요', standard: '다음에 봐요'),
      DialectSentence(dialect: '괜찮아요?', standard: '괜찮아요?'),
      DialectSentence(dialect: '천천히 해요', standard: '천천히 해요'),
      DialectSentence(dialect: '잘 부탁드려요', standard: '잘 부탁드려요'),
      DialectSentence(dialect: '오래 기다렸어요?', standard: '오래 기다렸어요?'),
    ],
  ),
  Region(
    name: '부산/경상도',
    emoji: '🌊',
    sentences: [
      DialectSentence(dialect: '와 거 뭐하노?', standard: '거기서 뭐해?'),
      DialectSentence(dialect: '밥 묵었나?', standard: '밥 먹었어?'),
      DialectSentence(dialect: '니 어디 가노?', standard: '너 어디 가?'),
      DialectSentence(dialect: '그거 내 꺼 아이가', standard: '그거 내 거 아니야?'),
      DialectSentence(dialect: '빨리 안 오나?', standard: '빨리 안 와?'),
      DialectSentence(dialect: '오늘 날씨 참 좋타', standard: '오늘 날씨 참 좋다'),
      DialectSentence(dialect: '같이 가자 아이가', standard: '같이 가자'),
      DialectSentence(dialect: '얼마 하노?', standard: '얼마야?'),
      DialectSentence(dialect: '참 맛있다 아이가', standard: '참 맛있다'),
      DialectSentence(dialect: '조심히 가래이', standard: '조심히 가'),
      DialectSentence(dialect: '담에 보자', standard: '다음에 보자'),
      DialectSentence(dialect: '괜찮나?', standard: '괜찮아?'),
      DialectSentence(dialect: '천천히 해라', standard: '천천히 해'),
      DialectSentence(dialect: '잘 부탁한다 아이가', standard: '잘 부탁해'),
      DialectSentence(dialect: '오래 기다렸나?', standard: '오래 기다렸어?'),
    ],
  ),
  Region(
    name: '전라도',
    emoji: '🌾',
    sentences: [
      DialectSentence(dialect: '거시기 그거 말이여', standard: '그거 말이야'),
      DialectSentence(dialect: '밥은 먹었당가?', standard: '밥은 먹었어?'),
      DialectSentence(dialect: '뭣이 중헌디', standard: '뭐가 중요한데'),
      DialectSentence(dialect: '잠깐만이라우', standard: '잠깐만요'),
      DialectSentence(dialect: '어디 갔다 왔소?', standard: '어디 갔다 왔어?'),
      DialectSentence(dialect: '오늘 날씨 좋당께', standard: '오늘 날씨 좋네'),
      DialectSentence(dialect: '같이 가씨요', standard: '같이 가요'),
      DialectSentence(dialect: '얼마당가요?', standard: '얼마예요?'),
      DialectSentence(dialect: '참 맛있당께', standard: '참 맛있네'),
      DialectSentence(dialect: '조심히 가씨요', standard: '조심히 가세요'),
      DialectSentence(dialect: '담에 봅시다', standard: '다음에 봐요'),
      DialectSentence(dialect: '괜찮당가요?', standard: '괜찮아요?'),
      DialectSentence(dialect: '천천히 허씨요', standard: '천천히 하세요'),
      DialectSentence(dialect: '잘 부탁허요', standard: '잘 부탁해요'),
      DialectSentence(dialect: '오래 기다렸당가?', standard: '오래 기다렸어요?'),
    ],
  ),
  Region(
    name: '충청도',
    emoji: '🏞️',
    sentences: [
      DialectSentence(dialect: '거기 뭐여?', standard: '거기 뭐야?'),
      DialectSentence(dialect: '밥은 먹었슈?', standard: '밥은 먹었어?'),
      DialectSentence(dialect: '어디 가유?', standard: '어디 가?'),
      DialectSentence(dialect: '그거 내 꺼여', standard: '그거 내 거야'),
      DialectSentence(dialect: '빨리 와유', standard: '빨리 와'),
      DialectSentence(dialect: '오늘 날씨 좋네유', standard: '오늘 날씨 좋네요'),
      DialectSentence(dialect: '같이 가유', standard: '같이 가요'),
      DialectSentence(dialect: '얼마여유?', standard: '얼마예요?'),
      DialectSentence(dialect: '맛있네유', standard: '맛있네요'),
      DialectSentence(dialect: '조심히 가유', standard: '조심히 가세요'),
      DialectSentence(dialect: '담에 봐유', standard: '다음에 봐요'),
      DialectSentence(dialect: '괜찮아유?', standard: '괜찮아요?'),
      DialectSentence(dialect: '천천히 해유', standard: '천천히 하세요'),
      DialectSentence(dialect: '잘 부탁혀유', standard: '잘 부탁해요'),
      DialectSentence(dialect: '오래 기다렸어유?', standard: '오래 기다렸어요?'),
    ],
  ),
  Region(
    name: '강원도',
    emoji: '🏔️',
    sentences: [
      DialectSentence(dialect: '뭐하는 거래요?', standard: '뭐하는 거예요?'),
      DialectSentence(dialect: '밥 먹었수?', standard: '밥 먹었어?'),
      DialectSentence(dialect: '어디 가우?', standard: '어디 가?'),
      DialectSentence(dialect: '그거 내 꺼래요', standard: '그거 내 거예요'),
      DialectSentence(dialect: '잠깐만이래요', standard: '잠깐만요'),
      DialectSentence(dialect: '오늘 날씨 좋래요', standard: '오늘 날씨 좋네요'),
      DialectSentence(dialect: '같이 가래요', standard: '같이 가요'),
      DialectSentence(dialect: '얼마래요?', standard: '얼마예요?'),
      DialectSentence(dialect: '맛있래요', standard: '맛있어요'),
      DialectSentence(dialect: '조심히 가래요', standard: '조심히 가세요'),
      DialectSentence(dialect: '담에 봐래요', standard: '다음에 봐요'),
      DialectSentence(dialect: '괜찮래요?', standard: '괜찮아요?'),
      DialectSentence(dialect: '천천히 해래요', standard: '천천히 하세요'),
      DialectSentence(dialect: '잘 부탁래요', standard: '잘 부탁해요'),
      DialectSentence(dialect: '오래 기다렸래요?', standard: '오래 기다렸어요?'),
    ],
  ),
  Region(
    name: '제주도',
    emoji: '🍊',
    sentences: [
      DialectSentence(dialect: '혼저 옵서예', standard: '혼자 오세요'),
      DialectSentence(dialect: '밥 먹엇수과?', standard: '밥 먹었어요?'),
      DialectSentence(dialect: '어디 감수광?', standard: '어디 가요?'),
      DialectSentence(dialect: '고맙수다', standard: '감사합니다'),
      DialectSentence(dialect: '잘 모르쿠다', standard: '잘 모르겠어요'),
      DialectSentence(dialect: '날씨 좋수다', standard: '날씨 좋네요'),
      DialectSentence(dialect: '같이 갑서예', standard: '같이 가요'),
      DialectSentence(dialect: '이거 얼마우꽈?', standard: '이거 얼마예요?'),
      DialectSentence(dialect: '맛있수다', standard: '맛있어요'),
      DialectSentence(dialect: '조심히 갑서예', standard: '조심히 가세요'),
      DialectSentence(dialect: '담에 봅서예', standard: '다음에 봐요'),
      DialectSentence(dialect: '괜찮수과?', standard: '괜찮아요?'),
      DialectSentence(dialect: '천천히 햅서예', standard: '천천히 하세요'),
      DialectSentence(dialect: '잘 부탁헙서예', standard: '잘 부탁해요'),
      DialectSentence(dialect: '오래 기다렸수과?', standard: '오래 기다렸어요?'),
    ],
  ),
];
