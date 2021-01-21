package component.member;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.regex.Pattern;

@Log4j
@Repository
public class MemberDAO {

    @Setter(onMethod_ = {@Autowired})
    private MemberMapper mapper;

    public MemberVO selects(String email) {
        return containSpecial(email) ? null : mapper.selects(email);
    }

    public int registerMember(MemberDTO memberDTO) {
        return mapper.registerMember(memberDTO);
    }

    public List<MemberTimerVO> selectTimer(@Param("email") String email) {
        if (containSpecial(email)) {
            return null;
        }
        return mapper.selectTimer(email);
    }

    public int insertTimer(HashMap<String, Object> hashMap) {
        return mapper.insertTimer(hashMap);
    }

    private boolean containSpecial(String str) {
        String pattern = "^[ㄱ-ㅎ가-힣a-zA-Z0-9@.]*$";
        return !Pattern.matches(pattern, str);
    }

}
