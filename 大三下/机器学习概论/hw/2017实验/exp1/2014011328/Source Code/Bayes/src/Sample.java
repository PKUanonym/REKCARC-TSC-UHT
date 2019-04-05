public class Sample {
    int age;
    String workclass;
    int fnlwgt;
    String education;
    int education_num;
    String marital_status;
    String occupation;
    String relationship;
    String race;
    String sex;
    int capital_gain;
    int capital_loss;
    int hours_per_week;
    String native_country;
    String result;
    String my_result;
    public Sample(){
    }
    public Sample(int age, String workclass, int fnlwgt, String education,
                  int education_num, String marital_status, String occupation,
                  String relationship, String race, String sex, int capital_gain, int capital_loss,
                  int hours_per_week, String native_country, String result){
        this.age=age;
        this.fnlwgt = fnlwgt;
        this.workclass=workclass;
        this.education=education;
        this.education_num=education_num;
        this.marital_status=marital_status;
        this.occupation=occupation;
        this.relationship=relationship;
        this.race=race;
        this.sex=sex;
        this.capital_gain=capital_gain;
        this.capital_loss=capital_loss;
        this.hours_per_week=hours_per_week;
        this.native_country=native_country;
        this.result=result;
    }


    public int getAge() {
        return age;
    }
    public void setAge(int age) {
        this.age = age;
    }
    public String getWorkclass() {
        return workclass;
    }
    public void setWorkclass(String workclass) {
        this.workclass = workclass;
    }
    public int getFnlwgt() {
        return fnlwgt;
    }
    public void setFnlwgt(int fnlwgt) {
        this.fnlwgt = fnlwgt;
    }
    public String getEducation() {
        return education;
    }
    public void setEducation(String education) {
        this.education = education;
    }
    public int getEducation_num() {
        return education_num;
    }
    public void setEducation_num(int education_num) {
        this.education_num = education_num;
    }

    public String getMarital_status() {
        return marital_status;
    }
    public void setMarital_status(String marital_status) {
        this.marital_status = marital_status;
    }
    public String getOccupation() {
        return occupation;
    }
    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getRelationship() {
        return relationship;
    }
    public void setRelationship(String relationship) {
        this.relationship = relationship;
    }
    public String getRace() {
        return race;
    }
    public void setRace(String race) {
        this.race = race;
    }
    public String getSex() {
        return sex;
    }
    public void setSex(String sex) {
        this.sex = sex;
    }
    public int getCapital_gain() {
        return capital_gain;
    }
    public void setCapital_gain(int capital_gain) {
        this.capital_gain = capital_gain;
    }
    public int getCapital_loss() {
        return capital_loss;
    }
    public void setCapital_loss(int capital_loss) {
        this.capital_loss = capital_loss;
    }
    public int getHours_per_week() {
        return hours_per_week;
    }
    public void setHours_per_week(int hours_per_week) {
        this.hours_per_week = hours_per_week;
    }
    public String getNative_country() {
        return native_country;
    }
    public void setNative_country(String native_country) {
        this.native_country = native_country;
    }
    public String getResult() {
        return result;
    }
    public void setResult(String result) {
        this.result = result;
    }
    public String getMy_result() {
        return my_result;
    }
    public void setMy_result(String my_result) {
        this.my_result = my_result;
    }
//    @Override
//    public String toString() {
//        return "Sample [age=" + age + ", workclass=" + workclass + ", education="
//                + education + ", marital_status=" + marital_status + ", occupation="
//                + occupation + "]";
//    }
}
