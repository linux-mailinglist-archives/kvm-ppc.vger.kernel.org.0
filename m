Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E4947584
	for <lists+kvm-ppc@lfdr.de>; Sun, 16 Jun 2019 17:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfFPPdz (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 16 Jun 2019 11:33:55 -0400
Received: from mail.ilande.co.uk ([46.43.2.167]:46438 "EHLO
        mail.default.ilande.uk0.bigv.io" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727156AbfFPPdz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 16 Jun 2019 11:33:55 -0400
Received: from host86-173-229-95.range86-173.btcentralplus.com ([86.173.229.95] helo=[192.168.1.65])
        by mail.default.ilande.uk0.bigv.io with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mark.cave-ayland@ilande.co.uk>)
        id 1hcXA2-00027R-Ry; Sun, 16 Jun 2019 16:33:39 +0100
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        paulus@ozlabs.org
References: <20190614185745.6863-1-mark.cave-ayland@ilande.co.uk>
 <871rzv4xx4.fsf@linux.ibm.com>
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
Message-ID: <6778e703-f408-28ed-d4d3-3e138cb4815b@ilande.co.uk>
Date:   Sun, 16 Jun 2019 16:33:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <871rzv4xx4.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 86.173.229.95
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        mail.default.ilande.uk0.bigv.io
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] KVM: PPC: Book3S PR: fix software breakpoints
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mail.default.ilande.uk0.bigv.io)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 14/06/2019 23:14, Fabiano Rosas wrote:

> Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk> writes:
> 
>> QEMU's kvm_handle_debug() function identifies software breakpoints by checking
>> for a value of 0 in kvm_debug_exit_arch's status field. Since this field isn't
> 
> LGTM, but let me start a discussion:
> 
> In arch/powerpc/include/uapi/asm/kvm.h I see the following:
> 
> 
> /*
>  * Defines for h/w breakpoint, watchpoint (read, write or both) and
>  * software breakpoint.
>  * These are used as "type" in KVM_SET_GUEST_DEBUG ioctl and "status"
>  * for KVM_DEBUG_EXIT.
>  */
> #define KVMPPC_DEBUG_NONE		0x0
> #define KVMPPC_DEBUG_BREAKPOINT		(1UL << 1)
> #define KVMPPC_DEBUG_WATCH_WRITE	(1UL << 2)
> #define KVMPPC_DEBUG_WATCH_READ		(1UL << 3)
> 
> 
> this seems to be biased towards the BookE implementation which uses
> KVMPPC_DEBUG_BREAKPOINT to indicate a "hardware breakpoint" (i.e. Instruction
> Address Compare - ISA v2 Book III-E, section 10.4.1), and then
> KVMPPC_DEBUG_NONE ends up implicitly meaning "software breakpoint" for
> Book3s PR/HV.
> 
>> explicitly set to 0 when the software breakpoint instruction is detected, any
>> previous non-zero value present causes a hang in QEMU as it tries to process
>> the breakpoint instruction incorrectly as a hardware breakpoint.
> 
> What QEMU does (again biased towards BookE) is to check the 'status'
> field and treat both h/w breakpoints and watchpoints as hardware
> breakpoints (which is correct in a sense) and then proceed to look for
> s/w breakpoints:
> 
>     if (arch_info->status) {
>         return kvm_handle_hw_breakpoint(cs, arch_info);
>     }
> 
>     if (kvm_find_sw_breakpoint(cs, arch_info->address)) {
>         return kvm_handle_sw_breakpoint(cs, arch_info->address);
>     }

Right so this feels a bit like BookE was used for the original implementation and
then the Book3S functionality followed on from that.

> So I wonder if it would not be beneficial for future developers if we
> drew the line and made a clear distinction between:
> 
>  software breakpoints - triggered by a KVMPPC_INST_SW_BREAKPOINT execution
>  hardware breakpoints - triggered by some register match
> 
> Maybe by turning the first two defines into:
> 
> #define KVMPPC_DEBUG_SW_BREAKPOINT 0x0
> #define KVMPPC_DEBUG_HW_BREAKPOINT (1UL << 1)

No objection from me, however I don't really have enough history with KVM PPC to be
able to opine as to whether this fits with the general design of
KVM/PPC/BookE/Book3S. I'm really coming at this from the perspective of toying with a
hobby project on my iMac G4 and fixing up the things I find are broken.

>> Ensure that the kvm_debug_exit_arch status field is set to 0 when the software
>> breakpoint instruction is detected (similar to the existing logic in booke.c
>> and e500_emulate.c) to restore software breakpoint functionality under Book3S
>> PR.
>>
>> Signed-off-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
>> ---
> 
> Anyway, the proposed patch fixes the issue.
> 
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

Great, thank you! Is this enough for the patch to be queued?

>>  arch/powerpc/kvm/emulate.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
>> index bb4d09c1ad56..6fca38ca791f 100644
>> --- a/arch/powerpc/kvm/emulate.c
>> +++ b/arch/powerpc/kvm/emulate.c
>> @@ -271,6 +271,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
>>  		 */
>>  		if (inst == KVMPPC_INST_SW_BREAKPOINT) {
>>  			run->exit_reason = KVM_EXIT_DEBUG;
>> +			run->debug.arch.status = 0;
>>  			run->debug.arch.address = kvmppc_get_pc(vcpu);
>>  			emulated = EMULATE_EXIT_USER;
>>  			advance = 0;


ATB,

Mark.
