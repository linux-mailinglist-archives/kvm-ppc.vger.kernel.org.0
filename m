Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2332A1FE94
	for <lists+kvm-ppc@lfdr.de>; Thu, 16 May 2019 06:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbfEPEoI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 16 May 2019 00:44:08 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38874 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfEPEoI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 16 May 2019 00:44:08 -0400
Received: by mail-pl1-f195.google.com with SMTP id f97so955422plb.5
        for <kvm-ppc@vger.kernel.org>; Wed, 15 May 2019 21:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=Z8I+0I8sDIflCFpPAoQhP1EyICzZb7WVM/1nhULuHrw=;
        b=ice1oxVas7vFf3d2tYQZSlDBcuCF7tL8hTp/6ZJutDXf4Y1lL9GM3KPkawoQMJrgHN
         DgDF1Yx/9iIbZFwygagysDH+DVXegWla+SfA7aE9ahsyLqwvA51ie1EjDSN1rVrZEiE5
         IoqsiTBwmuQi8QJ+rLKWd/8fTtUJxjS86cdnl+LclxcHP3Tf0shKwlWiKlrnJeUUc/jf
         /y1NqGFqvi4j3sqbdtS8sBMYJ72JIchsv/uLOnfpNm9yZwt0nvx6BhbOOeR+klc9+ZL+
         vVdGlKphv6+Ul8m/IYhv8H3LGLOkSnwK0+m4SK1nelbMviiQ4+coohhtYN5m1RQbpKNI
         yVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=Z8I+0I8sDIflCFpPAoQhP1EyICzZb7WVM/1nhULuHrw=;
        b=PiUQjivxBNIYXcGIQGpclYaJWLoHj7qbZpiwH33eXP5tLnoSMAWyyJ4089R6YoPg6K
         Kfr1tuXhorWW9d6TyJh8mNxY1j9sh0QEzit4VsNLG/hjuXv8qoeAQ8COvFcb5vHsBVGy
         tN8HIq2BX0foyfv6ZYBKSYOGMUjh6r0gvdwTkWCLO+b+7a8pv52NfWM+F84RGwkAolf9
         jIGEgDG43SvTE+sDB3W8xzCeWDPdUw941o1nELwGdXISLCVWu/yxUdYbmu31la1aavTf
         9kdoLKC1PaPmL6o6toRV0Kt+fUlCUNtKvjoczmldVot2++RgNJynsMA294lF1ByXM6xG
         vE9w==
X-Gm-Message-State: APjAAAU1n+tUnjpnvkQnlqAlFR1F9Rrbg6WZxH5BmDjUbShEVo0Zv/gC
        nOp8ukXYrYPBm0mosP0vL8Q=
X-Google-Smtp-Source: APXvYqx9WKdQ7HquXm2F81zvZWPeGeiOGJd5yj0YB2YHMdOUbkJGfib0x+v+Iya/gR2nZE1/CLG0pg==
X-Received: by 2002:a17:902:b18c:: with SMTP id s12mr29278558plr.181.1557981847545;
        Wed, 15 May 2019 21:44:07 -0700 (PDT)
Received: from localhost (193-116-124-212.tpgi.com.au. [193.116.124.212])
        by smtp.gmail.com with ESMTPSA id w189sm4595667pfw.147.2019.05.15.21.44.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 21:44:06 -0700 (PDT)
Date:   Thu, 16 May 2019 14:43:58 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v10 2/2] powerpc/64s: KVM update for reimplement book3s
 idle code in C
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     "Gautham R . Shenoy" <ego@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20190428114515.32683-1-npiggin@gmail.com>
        <20190428114515.32683-3-npiggin@gmail.com>
        <20190513064207.GA11679@blackberry>
In-Reply-To: <20190513064207.GA11679@blackberry>
MIME-Version: 1.0
User-Agent: astroid/0.14.0 (https://github.com/astroidmail/astroid)
Message-Id: <1557981765.4aikls5u00.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Paul Mackerras's on May 13, 2019 4:42 pm:
> On Sun, Apr 28, 2019 at 09:45:15PM +1000, Nicholas Piggin wrote:
>> This is the KVM update to the new idle code. A few improvements:
>>=20
>> - Idle sleepers now always return to caller rather than branch out
>>   to KVM first.
>> - This allows optimisations like very fast return to caller when no
>>   state has been lost.
>> - KVM no longer requires nap_state_lost because it controls NVGPR
>>   save/restore itself on the way in and out.
>> - The heavy idle wakeup KVM request check can be moved out of the
>>   normal host idle code and into the not-performance-critical offline
>>   code.
>> - KVM nap code now returns from where it is called, which makes the
>>   flow a bit easier to follow.
>=20
> One question below...
>=20
>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/=
book3s_hv_rmhandlers.S
>> index 58d0f1ba845d..f66191d8f841 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> ...
>> @@ -2656,6 +2662,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_300)
>> =20
>>  	lis	r3, LPCR_PECEDP@h	/* Do wake on privileged doorbell */
>> =20
>> +	/* Go back to host stack */
>> +	ld	r1, HSTATE_HOST_R1(r13)
>=20
> At this point we are in kvmppc_h_cede, which we branched to from
> hcall_try_real_mode, which came from the guest exit path, where we
> have already loaded r1 from HSTATE_HOST_R1(r13).  So if there is a
> path to get here with r1 not already set to HSTATE_HOST_R1(r13), then
> I missed it - please point it out to me.  Otherwise this statement
> seems superfluous.

I'm not sure why I put that there. I think you're right it could
be removed.

Thanks,
Nick
=
