-- 김영희 회원과 같은 지역에 사는
-- 회원들의 지역명, 아이디, 이름, 등급명을
-- 이름 오름차순으로 조회
SELECT
	AREA_NAME 지역명,
	MEMBER_ID 아이디,
	MEMBER_NAME 이름,
	GRADE_NAME 등급명
FROM TB_MEMBER 
JOIN TB_GRADE ON (GRADE = GRADE_CODE) 
JOIN TB_AREA USING (AREA_CODE)
WHERE AREA_CODE =
			(SELECT AREA_CODE
			 FROM TB_MEMBER
			 WHERE MEMBER_NAME = '김영희')
ORDER BY MEMBER_NAME ASC;

 





SELECT
	AREA_NAME 지역명,
	MEMBER_ID 아이디,
	MEMBER_NAME 이름,
	GRADE_NAME 등급명
FROM TB_MEMBER
JOIN TB_GRADE ON(GRADE = GRADE_CODE)
JOIN TB_AREA USING(AREA_CODE)
-- JOIN 간에 ON 내부의 AREA_CODE 컬럼이 어느 테이블의 것인지 알 수 없어 오류가 발생함.
-- 따라서 아래와 같이 수정해야 됨
-- 1) JOIN TB_AREA USING (AREA_CODE)
-- 2) JOIN TB_AREA ON (TB_MEMBER.AREA_CODE = TB_AREA.AREA_CODE)
WHERE AREA_CODE = (
			SELECT AREA_CODE
			FROM TB_MEMBER
			WHERE MEMBER_NAME = '김영희')
			-- WHERE절에서 별칭으로 호출 하려 하였으나,
			-- 해석 순서가 FROM -> WHERE -> SELECT 순서이기 때문에 별칭을 사용할 수 없다.
			-- 따라서 WHERE절에 이름을 'MEMBER_NAME'으로 수정해야 한다
			-- 또는 괄호()를 모두 삭제하고 TB_MEMBER 테이블에서 '김영희'의 지역번호에
			-- 해당하는 컬럼인 AREA_CODE '031'을 작성해도 된다
AND   MEMBER_NAME != '김영희'
-- 추가로 김영희와 같은 지역이기 때문에 김영희의 내용을 삭제해도 무방하다.
ORDER BY 이름 ASC;
-- 오름차순의 순서는 한글의 경우 ㄱ -> ㅎ, 영어의 경우 A-> Z 순으로 나타남
-- DESC는 정렬순서를 내림차순으로 설정하는 함수로, ASC(오름차순)으로 설정해야한다








