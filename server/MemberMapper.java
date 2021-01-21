package component.member;

import org.apache.ibatis.annotations.Param;

import java.util.HashMap;
import java.util.List;

public interface MemberMapper {
    MemberVO selects(String email); // 회원조회 (삭제예정)

    int registerMember(MemberDTO memberDTO); // 회원가입

    List<MemberTimerVO> selectTimer(@Param("email") String email);

    int insertTimer(HashMap<String,Object> hashMap);

}
