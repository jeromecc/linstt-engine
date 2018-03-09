wget https://linto.ai/linto-base.zip

n=0
while ! mkdir old_model$n
do
    n=$((n+1))
done

mv current_model old_model$n

mkdir -p current_model/uc1/model
cp gmm_hmm3.yaml current_model/uc1

unzip linto-base.zip -d current_model/uc1/model
