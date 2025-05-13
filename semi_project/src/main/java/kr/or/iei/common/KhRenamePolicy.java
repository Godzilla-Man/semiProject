package kr.or.iei.common;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import com.oreilly.servlet.multipart.FileRenamePolicy;

public class KhRenamePolicy implements FileRenamePolicy {
	
	@Override
	public File rename(File originalFile) {
		/*
		 * 서버에 저장될 파일 명칭
		 * 
		 * yyyyMMddHHmmssSSS_랜덤숫자5자리.확장자
		 */
		int ranNum = new Random().nextInt(10000) + 1; //1~10000까지 중 랜덤 숫자
		
		String str = "_" + String.format("%05d", ranNum); //"_랜덤숫자5자리"
		
		String name = originalFile.getName(); //사용자가 업로드한 파일 명칭 -> test.jpg
		String ext = null; //확장자를 저장할 변수
		
		int dot = name.lastIndexOf("."); //파일명 뒤에서부터 마침표(.)의 위치. 없으면 -1을 리턴
		
		if(dot != -1) { //파일명에 마침표가 있을 때
			ext = name.substring(dot); //.jpg
		}else {
			ext = "";
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		String serverFileName = sdf.format(new Date(System.currentTimeMillis())) + str + ext; //test.jpg -> 20250509121620123 + _05846 + .jpg
		
		//서블릿에서 생성한 오늘 날짜 폴더 하위에 새로이 생성한 명칭으로 업로드
		File newFile = new File(originalFile.getParent(), serverFileName);
		
		return newFile;
	}
}
