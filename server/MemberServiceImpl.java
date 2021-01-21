package component.member;

import component.mail.MailService;
import lombok.Setter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Random;

@Service
public class MemberServiceImpl implements MemberService {

    @Setter(onMethod_ = {@Autowired})
    private MemberDAO memberDAO;

    @Setter(onMethod_ = {@Autowired})
    private MailService mailService;

    @Setter(onMethod_ = {@Autowired})
    private BCryptPasswordEncoder passwordEncoder;

    /**
     * @param email for selecting memberDTO
     * @return
     */
    @Override
    public MemberVO selects(String email) {
        return memberDAO.selects(email);
    }

 
    @Override
    public int registerMember(MemberDTO memberDTO) {

        return memberDAO.registerMember(memberDTO);
    }


    @Override
    public List<MemberTimerVO> selectTimer(String email) {
        return memberDAO.selectTimer(email);
    }

  
    @Override
    public int insertTimer(HashMap<String, Object> hashMap) {
        return memberDAO.insertTimer(hashMap);
    }

    private String generateSalt() {
        Random random = new Random();

        byte[] salt = new byte[4];
        random.nextBytes(salt);

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < salt.length; i++) {
            // byte 값을 Hex 값으로 바꾸기.
            sb.append(String.format("%02x", salt[i]));
        }
        return sb.toString();
    }

}

