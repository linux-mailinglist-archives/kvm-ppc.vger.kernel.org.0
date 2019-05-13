Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901A11BDA2
	for <lists+kvm-ppc@lfdr.de>; Mon, 13 May 2019 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbfEMTPb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 13 May 2019 15:15:31 -0400
Received: from mail.ilande.co.uk ([46.43.2.167]:49194 "EHLO
        mail.default.ilande.uk0.bigv.io" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbfEMTPb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 13 May 2019 15:15:31 -0400
Received: from host86-177-156-188.range86-177.btcentralplus.com ([86.177.156.188] helo=[192.168.1.65])
        by mail.default.ilande.uk0.bigv.io with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mark.cave-ayland@ilande.co.uk>)
        id 1hQGPR-00008t-7k; Mon, 13 May 2019 20:14:49 +0100
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org
References: <e84fd80c-d6a6-8f19-a4e1-ed309fa68aa9@ilande.co.uk>
 <87zhnq1atq.fsf@linux.ibm.com>
From:   Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Openpgp: preference=signencrypt
Autocrypt: addr=mark.cave-ayland@ilande.co.uk; keydata=
 mQENBFQJuzwBCADAYvxrwUh1p/PvUlNFwKosVtVHHplgWi5p29t58QlOUkceZG0DBYSNqk93
 3JzBTbtd4JfFcSupo6MNNOrCzdCbCjZ64ik8ycaUOSzK2tKbeQLEXzXoaDL1Y7vuVO7nL9bG
 E5Ru3wkhCFc7SkoypIoAUqz8EtiB6T89/D9TDEyjdXUacc53R5gu8wEWiMg5MQQuGwzbQy9n
 PFI+mXC7AaEUqBVc2lBQVpAYXkN0EyqNNT12UfDLdxaxaFpUAE2pCa2LTyo5vn5hEW+i3VdN
 PkmjyPvL6DdY03fvC01PyY8zaw+UI94QqjlrDisHpUH40IUPpC/NB0LwzL2aQOMkzT2NABEB
 AAG0ME1hcmsgQ2F2ZS1BeWxhbmQgPG1hcmsuY2F2ZS1heWxhbmRAaWxhbmRlLmNvLnVrPokB
 OAQTAQIAIgUCVAm7PAIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQW8LFb64PMh9f
 NAgAuc3ObOEY8NbZko72AGrg2tWKdybcMVITxmcor4hb9155o/OWcA4IDbeATR6cfiDL/oxU
 mcmtXVgPqOwtW3NYAKr5g/FrZZ3uluQ2mtNYAyTFeALy8YF7N3yhs7LOcpbFP7tEbkSzoXNG
 z8iYMiYtKwttt40WaheWuRs0ZOLbs6yoczZBDhna3Nj0LA3GpeJKlaV03O4umjKJgACP1c/q
 T2Pkg+FCBHHFP454+waqojHp4OCBo6HyK+8I4wJRa9Z0EFqXIu8lTDYoggeX0Xd6bWeCFHK3
 DhD0/Xi/kegSW33unsp8oVcM4kcFxTkpBgj39dB4KwAUznhTJR0zUHf63LkBDQRUCbs8AQgA
 y7kyevA4bpetM/EjtuqQX4U05MBhEz/2SFkX6IaGtTG2NNw5wbcAfhOIuNNBYbw6ExuaJ3um
 2uLseHnudmvN4VSJ5Hfbd8rhqoMmmO71szgT/ZD9MEe2KHzBdmhmhxJdp+zQNivy215j6H27
 14mbC2dia7ktwP1rxPIX1OOfQwPuqlkmYPuVwZP19S4EYnCELOrnJ0m56tZLn5Zj+1jZX9Co
 YbNLMa28qsktYJ4oU4jtn6V79H+/zpERZAHmH40IRXdR3hA+Ye7iC/ZpWzT2VSDlPbGY9Yja
 Sp7w2347L5G+LLbAfaVoejHlfy/msPeehUcuKjAdBLoEhSPYzzdvEQARAQABiQEfBBgBAgAJ
 BQJUCbs8AhsMAAoJEFvCxW+uDzIfabYIAJXmBepHJpvCPiMNEQJNJ2ZSzSjhic84LTMWMbJ+
 opQgr5cb8SPQyyb508fc8b4uD8ejlF/cdbbBNktp3BXsHlO5BrmcABgxSP8HYYNsX0n9kERv
 NMToU0oiBuAaX7O/0K9+BW+3+PGMwiu5ml0cwDqljxfVN0dUBZnQ8kZpLsY+WDrIHmQWjtH+
 Ir6VauZs5Gp25XLrL6bh/SL8aK0BX6y79m5nhfKI1/6qtzHAjtMAjqy8ChPvOqVVVqmGUzFg
 KPsrrIoklWcYHXPyMLj9afispPVR8e0tMKvxzFBWzrWX1mzljbBlnV2n8BIwVXWNbgwpHSsj
 imgcU9TTGC5qd9g=
Message-ID: <1fc3a3f6-c7a8-8759-ec4d-304b2bd832ef@ilande.co.uk>
Date:   Mon, 13 May 2019 20:15:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <87zhnq1atq.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 86.177.156.188
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        mail.default.ilande.uk0.bigv.io
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: KVM: Book3S PR: unbreaking software breakpoints
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mail.default.ilande.uk0.bigv.io)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 13/05/2019 19:14, Fabiano Rosas wrote:

> Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk> writes:
> 
>> For comparison both booke.c and e500_emulate.c set debug.arch.status = 0 for software
>> breakpoints, whereas both book3s_hv.c and book3s_pr.c do not. Given that emulate.c
>> contains shared code for handling software breakpoints, would the following simple
>> patch suffice?
>>
>>
>> diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
>> index 9f5b8c01c4e1..e77becaad5dd 100644
>> --- a/arch/powerpc/kvm/emulate.c
>> +++ b/arch/powerpc/kvm/emulate.c
>> @@ -282,6 +282,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct
>> kvm_vcpu *vcpu)
>>                  */
>>                 if (inst == KVMPPC_INST_SW_BREAKPOINT) {
>>                         run->exit_reason = KVM_EXIT_DEBUG;
>> +                       run->debug.arch.status = 0;
>>                         run->debug.arch.address = kvmppc_get_pc(vcpu);
>>                         emulated = EMULATE_EXIT_USER;
>>                         advance = 0;
> 
> This looks reasonable to me.

Great, thanks for the review! I'm fairly busy for the next few days, but will send a
proper patch towards the end of the week.


ATB,

Mark.
