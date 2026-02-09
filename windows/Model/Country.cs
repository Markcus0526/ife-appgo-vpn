using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AppGo.Controller;

namespace AppGo.Model
{
    public class CountryInfo
    {
        public string Code;
        public string ChinaName;
        public string EnglishName;
        public string PhoneCode;
        public float Price;
        public string Flag;

        public CountryInfo(string code, string chinaName, string englishName, string phoneCode, float price, string flag)
        {
            this.Code = code;
            this.ChinaName = chinaName;
            this.EnglishName = englishName;
            this.PhoneCode = phoneCode;
            this.Price = price;
            this.Flag = flag;
        }
    }

    public class CountryTemplate
    {
        public static CountryInfo[] CountryInfos = {
            new CountryInfo("CN", "中国", "China", "+86", 0.05f, "ic_flag_cn"),
            new CountryInfo("HK", "香港", "Hong Kong", "+852", 0.227f, "ic_flag_hk"),
            new CountryInfo("MO", "澳门", "Macau", "+853", 0.076f, "ic_flag_mo"),
            new CountryInfo("TW", "台湾", "Taiwan", "+886", 0.16f, "ic_flag_tw"),
            new CountryInfo("US", "美国", "United States", "+1", 0.037f, "ic_flag_us"),
            new CountryInfo("CA", "加拿大", "Canada", "+1", 0.037f, "ic_flag_ca"),
            new CountryInfo("MX", "墨西哥", "Mexico", "+52", 0.294f, "ic_flag_mx"),
            new CountryInfo("NL", "荷兰", "Netherlands", "+31", 0.554f, "ic_flag_nl"),
            new CountryInfo("BE", "比利时", "Belgium", "+32", 0.673f, "ic_flag_be"),
            new CountryInfo("FR", "法国", "France", "+33", 0.311f, "ic_flag_fr"),
            new CountryInfo("ES", "西班牙", "Spain", "+34", 0.336f, "ic_flag_es"),
            new CountryInfo("IT", "意大利", "Italy", "+39", 0.336f, "ic_flag_it"),
            new CountryInfo("CH", "瑞士", "Switzerland", "+41", 0.353f, "ic_flag_ch"),
            new CountryInfo("AT", "奥地利", "Austria", "+43", 0.42f, "ic_flag_at"),
            new CountryInfo("GB", "英国", "United Kingdom", "+44", 0.218f, "ic_flag_gb"),
            new CountryInfo("DK", "丹麦", "Denmark", "+45", 0.139f, "ic_flag_dk"),
            new CountryInfo("SE", "瑞典", "Sweden", "+46", 0.302f, "ic_flag_se"),
            new CountryInfo("NO", "挪威", "Norway", "+47", 0.328f, "ic_flag_no"),
            new CountryInfo("PL", "波兰", "Poland", "+48", 0.193f, "ic_flag_pl"),
            new CountryInfo("DE", "德国", "Germany", "+49", 0.42f, "ic_flag_de"),
            new CountryInfo("PT", "葡萄牙", "Portugal", "+351", 0.337f, "ic_flag_pt"),
            new CountryInfo("FI", "芬兰", "Finland", "+358", 0.555f, "ic_flag_fi"),
            new CountryInfo("RU", "俄罗斯", "Russia", "+7", 0.16f, "ic_flag_ru"),
            new CountryInfo("UA", "乌克兰", "Ukraine", "+380", 0.588f, "ic_flag_ua"),
            new CountryInfo("AR", "阿根廷", "Argentina", "+54", 0.409f, "ic_flag_ar"),
            new CountryInfo("BR", "巴西", "Brazil", "+55", 0.404f, "ic_flag_br"),
            new CountryInfo("CL", "智利", "Chile", "+56", 0.367f, "ic_flag_cl"),
            new CountryInfo("MY", "马来西亚", "Malaysia", "+60", 0.193f, "ic_flag_my"),
            new CountryInfo("AU", "澳大利亚", "Australia", "+61", 0.353f, "ic_flag_au"),
            new CountryInfo("ID", "印度尼西亚", "Indonesia", "+62", 0.143f, "ic_flag_id"),
            new CountryInfo("PH", "菲律宾", "Philippines", "+63", 0.249f, "ic_flag_ph"),
            new CountryInfo("NZ", "新西兰", "New Zealand", "+64", 0.582f, "ic_flag_nz"),
            new CountryInfo("SG", "新加坡", "Singapore", "+65", 0.244f, "ic_flag_sg"),
            new CountryInfo("TH", "泰国", "Thailand", "+66", 0.143f, "ic_flag_th"),
            new CountryInfo("JP", "日本", "Japan", "+81", 0.378f, "ic_flag_jp"),
            new CountryInfo("KR", "韩国", "South Korea", "+82", 0.101f, "ic_flag_kr"),
            new CountryInfo("VN", "越南", "Vietnam", "+84", 0.414f, "ic_flag_vn"),
            new CountryInfo("TR", "土耳其", "Turkey", "+90", 0.126f, "ic_flag_tr"),
            new CountryInfo("IN", "印度", "India", "+91", 0.05f, "ic_flag_in"),
            new CountryInfo("PK", "巴基斯坦", "Pakistan", "+92", 0.168f, "ic_flag_pk"),
            new CountryInfo("IR", "伊朗", "Iran", "+98", 0.266f, "ic_flag_ir"),
            new CountryInfo("SA", "沙特阿拉伯", "Saudi Arabia", "+966", 0.189f, "ic_flag_sa"),
            new CountryInfo("AE", "阿拉伯 联合酋长国", "United Arab Emirates", "+971", 0.193f, "ic_flag_ae"),
            new CountryInfo("IL", "以色列", "Israel", "+972", 0.472f, "ic_flag_il"),
            new CountryInfo("MN", "蒙古", "Mongolia", "+976", 0.156f, "ic_flag_mn"),
            new CountryInfo("ZA", "南非", "South Africa", "+27", 0.146f, "ic_flag_za"),
            new CountryInfo("Trial", "试用", "Trial", "", 0.146f, "ic_flag_user")
        };

        public static string GetFlagName(string code)
        {
            for (int i = 0; i < CountryInfos.Length; i++)
            {
                if (code == CountryInfos[i].Code)
                {
                    return CountryInfos[i].Flag;
                }
            }

            return "ic_flag_user";
        }

        public static string GetCountryName(string code)
        {
            for (int i = 0; i < CountryInfos.Length; i++)
            {
                if (code == CountryInfos[i].Code)
                {
                    if (LocalizationManager.CurrentLanguage == LocalizationManager.Chinese)
                    {
                        return CountryInfos[i].ChinaName;
                    }
                    else
                    {
                        return CountryInfos[i].EnglishName;
                    }
                }
            }

            return code;
        }

        public static string getCryptPhoneNumber(string mobile)
        {
            if (mobile.Length < 10  || mobile.Contains("+") == false)
            {
                return mobile;
            }

            string cryptNumber = "";

            for (int i = 0; i < CountryInfos.Length; i++)
            {
                string countrycode = mobile.Substring(0, 4);

                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    cryptNumber = mobile.Substring(4, 7) + fillCryptCode(mobile.Length - 10) + mobile.Substring(mobile.Length - 3);
                    break;
                }

                countrycode = mobile.Substring(0, 3);
                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    cryptNumber = mobile.Substring(3, 6) + fillCryptCode(mobile.Length - 9) + mobile.Substring(mobile.Length - 3);
                    break;
                }

                countrycode = mobile.Substring(0, 2);
                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    cryptNumber = mobile.Substring(2, 5) + fillCryptCode(mobile.Length - 8) + mobile.Substring(mobile.Length - 3);
                    break;
                }
            }

            return cryptNumber;
        }

        public static string getPhonePrefix(string mobile)
        {
            if (mobile.Contains("+") == false)
            {
                return "";
            }

            string prefix = "";

            for (int i = 0; i < CountryInfos.Length; i++)
            {
                var countrycode = mobile.Substring(0, 4);
                if (countrycode == CountryInfos[i].PhoneCode) {
                    prefix = countrycode;
                    break;
                }

                countrycode = mobile.Substring(0, 3);
                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    prefix = countrycode;
                }

                countrycode = mobile.Substring(0, 2);
                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    prefix = countrycode;
                }
            }

            return prefix;
        }

        public static string getNativePhoneNumber(string mobile)
        {
            if (mobile.Contains("+") == false)
            {
                return mobile;
            }

            string nativeNumber = "";

            for (int i = 0; i < CountryInfos.Length; i++)
            {
                string countrycode = mobile.Substring(0, 4);
                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    nativeNumber = mobile.Substring(4);
                    break;
                }

                countrycode = mobile.Substring(0, 3);
                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    nativeNumber = mobile.Substring(3);
                    break;
                }

                countrycode = mobile.Substring(0, 2);
                if (countrycode == CountryInfos[i].PhoneCode)
                {
                    nativeNumber = mobile.Substring(2);
                    break;
                }
            }

            return nativeNumber;
        }

        public static string fillCryptCode(int count)
        {
            string result = "";
            for (int i = 0; i < count; i++)
            {
                result += "*";
            }

            return result;
        }
    }

}


