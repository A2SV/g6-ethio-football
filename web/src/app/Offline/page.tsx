// components/SoccerPage.js

import Image from "next/image";

const SoccerPage = () => {
  return (
    <div className="container">
      <div className="main-content">
        <section className="section club-bios">
          <h2 className="section-heading">Club Bios</h2>
          <div className="card-container">
            {/* Card for Arsenal */}
            <div className="card">
              <h3 className="card-title">Arsenal</h3>
              <div className="card-body">
                <Image
                  src="/arsenal-saka.jpg" // You'll need to add this image to your /public directory
                  alt="Bukayo Saka celebrating a goal for Arsenal"
                  width={150}
                  height={100}
                />
                <p>
                  Bukayo Saka's brilliant double helped Arsenal secure a crucial
                  3-1 victory over Chelsea at Emirates Stadium. The Gunners now
                  sit five points clear at the top of the table.
                </p>
              </div>
            </div>

            {/* Card for Manchester United */}
            <div className="card">
              <h3 className="card-title">Manchester United</h3>
              <div className="card-body">
                <Image
                  src="/man-united.jpg" // You'll need to add this image
                  alt="Manchester United player celebrating"
                  width={150}
                  height={100}
                />
                <p>
                  Bukayo Saka's brilliant double helped Arsenal secure a crucial
                  3-1 victory over Chelsea at Emirates Stadium. The Gunners now
                  sit five points clear at the top of the table.
                </p>
              </div>
            </div>

            {/* Card for Tottenham */}
            <div className="card">
              <h3 className="card-title">Tottenham</h3>
              <div className="card-body">
                <Image
                  src="/tottenham.jpg" // You'll need to add this image
                  alt="Tottenham player celebrating"
                  width={150}
                  height={100}
                />
                <p>
                  Bukayo Saka's brilliant double helped Arsenal secure a crucial
                  3-1 victory over Chelsea at Emirates Stadium. The Gunners now
                  sit five points clear at the top of the table.
                </p>
              </div>
            </div>

            {/* Duplicate Tottenham card from the image */}
            <div className="card">
              <h3 className="card-title">Tottenham</h3>
              <div className="card-body">
                <Image
                  src="/tottenham.jpg"
                  alt="Tottenham player celebrating"
                  width={150}
                  height={100}
                />
                <p>
                  Bukayo Saka's brilliant double helped Arsenal secure a crucial
                  3-1 victory over Chelsea at Emirates Stadium. The Gunners now
                  sit five points clear at the top of the table.
                </p>
              </div>
            </div>
          </div>
        </section>

        <section className="section faqs">
          <h2 className="section-heading">FAQs</h2>
          <div className="faq-item">
            <h3 className="faq-question">
              What does the term "hat trick" mean in soccer?
            </h3>
            <p className="faq-answer">
              A hat trick is a term used for the same player having scored three
              goals in a single game.
            </p>
          </div>
          <div className="faq-item">
            <h3 className="faq-question">
              What is the term "hat trick" mean in soccer?
            </h3>
            <p className="faq-answer">
              A hat trick is a term used for the same player having scored three
              goals in a single game.
            </p>
          </div>
          <div className="faq-item">
            <h3 className="faq-question">What is "offside" in soccer?</h3>
            <p className="faq-answer">
              A player shall be called for an offside penalty in soccer if, at
              the moment the ball is passed to him by a teammate, he is in an
              offside position (does not have at least one defender between him
              and at least one defender level with him and the goal-line.
            </p>
          </div>
          <div className="faq-item">
            <h3 className="faq-question">What is "offside" in soccer?</h3>
            <p className="faq-answer">
              A player shall be called for an offside penalty in soccer if, at
              the moment the ball is passed to him by a teammate, he is in an
              offside position (does not have at least one defender between him
              and at least one defender level with him and the goal-line.
            </p>
          </div>
        </section>
      </div>

      <section className="section football-rules">
        <h2 className="section-heading">Football Rules</h2>
        <div className="rule-cards-container">
          <div className="rule-card">
            <Image
              src="/goalkeeper-hands.jpg" // You'll need to add this image
              alt="A goalkeeper catching the ball"
              width={150}
              height={100}
            />
            <h4 className="rule-card-title">No Hands</h4>
            <p className="rule-card-text">
              Only goalkeepers can use their hands.
            </p>
          </div>
          <div className="rule-card">
            <Image
              src="/goalkeeper-hands.jpg"
              alt="A goalkeeper catching the ball"
              width={150}
              height={100}
            />
            <h4 className="rule-card-title">No Hands</h4>
            <p className="rule-card-text">
              Only goalkeepers can use their hands.
            </p>
          </div>
          <div className="rule-card">
            <Image
              src="/goalkeeper-hands.jpg"
              alt="A goalkeeper catching the ball"
              width={150}
              height={100}
            />
            <h4 className="rule-card-title">No Hands</h4>
            <p className="rule-card-text">
              Only goalkeepers can use their hands.
            </p>
          </div>
          <div className="rule-card">
            <Image
              src="/goalkeeper-hands.jpg"
              alt="A goalkeeper catching the ball"
              width={150}
              height={100}
            />
            <h4 className="rule-card-title">No Hands</h4>
            <p className="rule-card-text">
              Only goalkeepers can use their hands.
            </p>
          </div>
          <div className="rule-card">
            <Image
              src="/goalkeeper-hands.jpg"
              alt="A goalkeeper catching the ball"
              width={150}
              height={100}
            />
            <h4 className="rule-card-title">No Hands</h4>
            <p className="rule-card-text">
              Only goalkeepers can use their hands.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
};

export default SoccerPage;
