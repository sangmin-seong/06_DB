-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명

--1) 전지연 사원이 있는 부서조회
SELECT 
	DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_NAME = '전지연';

--2) 사번, 사원명, 전화번호, 고용일, 부서명 조회
SELECT
 EMP_ID,
 EMP_NAME,
 PHONE,
 HIRE_DATE,
 DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = (
	SELECT 
		DEPT_TITLE
	FROM EMPLOYEE
	JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
	WHERE EMP_NAME = '전지연'
)
AND EMP_NAME != '전지연';

-- 2. 고용일이 2010년도 이후인 사원들 중 급여가 가장 높은 사원의
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.

--1) 2010년 이후 입사자
SELECT
	MAX(SALARY)
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2010;

--2) 1)중에서 급여가 가장 많은 사람의
-- 	 사번, 사원명, 전화번호, 급여, 직급
SELECT
	EMP_ID,
	EMP_NAME,
	PHONE,
	SALARY,
	JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY = (
	SELECT
		MAX(SALARY)
	FROM EMPLOYEE
	WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2010
);
 

-- 3. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명

-- 1) 같은 부서코드, 같은 직급코드
SELECT
	DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';

-- 2) 사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT
	EMP_ID,
	EMP_NAME,
	DEPT_CODE,
	JOB_CODE,
	DEPT_TITLE,
	JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) =(
	SELECT
		DEPT_CODE, JOB_CODE
	FROM EMPLOYEE
	WHERE EMP_NAME = '노옹철'
)
AND EMP_NAME != '노옹철';


-- 4. 2010년도에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오
-- 사번, 이름, 부서코드, 직급코드, 고용일

-- 1) 2010년 입사자
SELECT
	DEPT_CODE, JOB_CODE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2010;

-- 2) 1)과 같은 사람
SELECT
	EMP_ID,
	EMP_NAME,
	DEPT_CODE,
	JOB_CODE,
	HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (
		SELECT
			DEPT_CODE, JOB_CODE
		FROM EMPLOYEE
		JOIN JOB USING (JOB_CODE)
		WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2010
);




-- 5. 87년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일

-- 1) 87년생 여자 사원의 부서
SELECT
	DEPT_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) = '87'
AND   SUBSTR(EMP_NO,8,1) = '2';

-- 2) 1)과 동일한 사원
SELECT
	EMP_ID,
	EMP_NAME
	DEPT_CODE,
	MANAGER_ID,
	EMP_NO,
	HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (
		SELECT
			DEPT_CODE, MANAGER_ID
		FROM EMPLOYEE
		WHERE SUBSTR(EMP_NO,1,2) = '87'
		AND   SUBSTR(EMP_NO,8,1) = '2'
);


-- 6. 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회..
SELECT 
	EMP_ID,
	EMP_NAME,
	NVL(DEPT_TITLE,'소속 없음'),
	JOB_NAME,
	HIRE_DATE
FROM EMPLOYEE "MAIN"
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE HIRE_DATE = (
	SELECT MIN(HIRE_DATE)
	FROM EMPLOYEE "SUB"
	WHERE NVL(SUB.DEPT_CODE,'소속 없음') 
						= NVL(MAIN.DEPT_CODE,'소속 없음')
	AND ENT_YN != 'Y'
);


-- 7. 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 만 나이, 보너스 포함 연봉( (급여 * (1 + 보너스)) * 12)을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호)



-- 만나이 조회
SELECT
	FLOOR((CURRENT_DATE-TO_DATE(SUBSTR(19||EMP_NO,1,8)))/365) "만 나이"
FROM EMPLOYEE;


SELECT
	EMP_ID 사번,
	EMP_NAME 이름,
	JOB_NAME 직급명,
	FLOOR((CURRENT_DATE-TO_DATE(SUBSTR(19||EMP_NO,1,8)))/365) AS "만 나이",
	'\'||(SALARY * (1 + NVL(BONUS, 0)) * 12) AS "보너스 포함 연봉"
FROM EMPLOYEE MAIN
JOIN JOB J ON(MAIN.JOB_CODE =J.JOB_CODE)
WHERE FLOOR((CURRENT_DATE-TO_DATE(SUBSTR(19||EMP_NO,1,8)))/365) = (
	SELECT MIN(FLOOR((CURRENT_DATE-TO_DATE(SUBSTR(19||EMP_NO,1,8)))/365))
	FROM EMPLOYEE SUB
	WHERE NVL(SUB.JOB_CODE, '소속 없음') = NVL(MAIN.JOB_CODE,'소속없음')
)
ORDER BY "만 나이" DESC;






















