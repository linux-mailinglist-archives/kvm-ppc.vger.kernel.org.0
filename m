Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFEC1A81C
	for <lists+kvm-ppc@lfdr.de>; Sat, 11 May 2019 16:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfEKOcW (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 11 May 2019 10:32:22 -0400
Received: from mail.ilande.co.uk ([46.43.2.167]:46784 "EHLO
        mail.default.ilande.uk0.bigv.io" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbfEKOcW (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 11 May 2019 10:32:22 -0400
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 May 2019 10:32:21 EDT
Received: from host86-177-156-188.range86-177.btcentralplus.com ([86.177.156.188] helo=[192.168.1.65])
        by mail.default.ilande.uk0.bigv.io with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <mark.cave-ayland@ilande.co.uk>)
        id 1hPSfe-000657-VR; Sat, 11 May 2019 15:08:15 +0100
To:     kvm-ppc@vger.kernel.org
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
Cc:     paulus@ozlabs.org
Message-ID: <e84fd80c-d6a6-8f19-a4e1-ed309fa68aa9@ilande.co.uk>
Date:   Sat, 11 May 2019 15:08:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 86.177.156.188
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        mail.default.ilande.uk0.bigv.io
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Subject: KVM: Book3S PR: unbreaking software breakpoints
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on mail.default.ilande.uk0.bigv.io)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi all,

Whilst trying to investigate some issues with MacOS under KVM PR I noticed that when
setting software breakpoints the KVM VCPU would stop as requested, but QEMU's gdbstub
would hang indefinitely.

I eventually traced it down to this code in QEMU's target/ppc/kvm.c:


static int kvm_handle_debug(PowerPCCPU *cpu, struct kvm_run *run)
{
    CPUState *cs = CPU(cpu);
    CPUPPCState *env = &cpu->env;
    struct kvm_debug_exit_arch *arch_info = &run->debug.arch;

    if (cs->singlestep_enabled) {
        return kvm_handle_singlestep();
    }

    if (arch_info->status) {
        return kvm_handle_hw_breakpoint(cs, arch_info);
    }

    if (kvm_find_sw_breakpoint(cs, arch_info->address)) {
        return kvm_handle_sw_breakpoint();
    }


The problem here is that with Book3S PR on my Mac hardware, run->debug.arch.status !=
0 which causes QEMU to think that this is a hardware breakpoint and so the software
breakpoint doesn't get handled correctly.

For comparison both booke.c and e500_emulate.c set debug.arch.status = 0 for software
breakpoints, whereas both book3s_hv.c and book3s_pr.c do not. Given that emulate.c
contains shared code for handling software breakpoints, would the following simple
patch suffice?


diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 9f5b8c01c4e1..e77becaad5dd 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -282,6 +282,7 @@ int kvmppc_emulate_instruction(struct kvm_run *run, struct
kvm_vcpu *vcpu)
                 */
                if (inst == KVMPPC_INST_SW_BREAKPOINT) {
                        run->exit_reason = KVM_EXIT_DEBUG;
+                       run->debug.arch.status = 0;
                        run->debug.arch.address = kvmppc_get_pc(vcpu);
                        emulated = EMULATE_EXIT_USER;
                        advance = 0;


ATB,

Mark.
