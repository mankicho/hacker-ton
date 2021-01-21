package component.member;

import org.apache.ibatis.annotations.Param;

import java.util.HashMap;
import java.util.List;

public interface MemberService {
    MemberVO selects(String email);

    int registerMember(MemberDTO memberDTO);

    List<MemberTimerVO> selectTimer(String email);

    int insertTimer(HashMap<String,Object> hashMap);


}
