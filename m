Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0F619CE84
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 Apr 2020 04:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388951AbgDCCPq (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 2 Apr 2020 22:15:46 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35813 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgDCCPq (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 2 Apr 2020 22:15:46 -0400
Received: by mail-pj1-f65.google.com with SMTP id g9so2300223pjp.0
        for <kvm-ppc@vger.kernel.org>; Thu, 02 Apr 2020 19:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=tnnT8LQ/nvrWPvlSi0XSrAkCxhkdXnxzRfo9zb1p+2A=;
        b=c8Q6ct3nKtj3rAVbnDKsUMHktjvmGJYhqlXKXJjPu186EXHCSiQ8PU1ZfBW2kszEy3
         6RWftxFEAW7DjSREBNhHN5FfSYklLHhvMmXt5sj7lBRSgzYObxi/Ysd/msp33GrxoN2+
         a945pI9PiEc0B97I2rZvmmXmzp9JmmGzBu04WuxSGpJ5yzOrhvbFgQPyZcJdphRFnUf5
         RQj1A2wKy+2cMt4RlhHdITwTx423U/GdGZjMd2C/Iprmax9Td6CT8zZgGVJhJWpsqGNn
         s7xtM7liXgHIp9LAZdT203Va7gKINLu0AZ2Wj1ITyCzRHoqmFT0gTPPgiGiq+Wc1vaXp
         gTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=tnnT8LQ/nvrWPvlSi0XSrAkCxhkdXnxzRfo9zb1p+2A=;
        b=rCL64EYUCSQiqeF3Azz784JW6li/5kg0mPO6ukfd6M7BUI5Kbj0bC44UOzb6DkTu9H
         3/SHac5M1RIvmyqlM9LyNXt/AId9UXx10E+2tT37Gs3k0eEwpVgfzjsea6MBaQWrMwmO
         8E81iFQefnlwKbGt6Wm5cq49lFDUQldx7pNhq2/9Ri7mGhtWO/3hwYcgm4RgSbemtbSg
         Rc6HJtseVoEguhMt0mvKh9D38YsiBArKdxWv4vNDQzK01UG2W+HCa2WBYdsqifjc7o9c
         TcYevAbC7GYWBxIPZ4S4DSCIFBjpxYYl+lbOKU4j3U1HP4vRtYzMUT29rAOwdjXE4ZKD
         v7Cg==
X-Gm-Message-State: AGi0PuaXLz/SP2OyGZRnLQs3ed3zLjrWP+kuEDeH4mnCjXpT2dwIjmoG
        pTsTfSY418WmEMiFwD5NwB4=
X-Google-Smtp-Source: APiQypIBzNVotcF4KzWzOppS2wHZuAesXitmqIgSOWZBFxOaODpqf7CtYObixOPdla9dq6I9XmGn8w==
X-Received: by 2002:a17:90a:c085:: with SMTP id o5mr6699425pjs.85.1585880144624;
        Thu, 02 Apr 2020 19:15:44 -0700 (PDT)
Received: from localhost (60-241-117-97.tpgi.com.au. [60.241.117.97])
        by smtp.gmail.com with ESMTPSA id y142sm4764634pfc.53.2020.04.02.19.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 19:15:43 -0700 (PDT)
Date:   Fri, 03 Apr 2020 12:15:38 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [RFC/PATCH  1/3] powerpc/kvm: Handle H_FAC_UNAVAIL when guest
 executes stop.
To:     Bharata B Rao <bharata@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linuxppc-dev@ozlabs.org
References: <1585656658-1838-1-git-send-email-ego@linux.vnet.ibm.com>
        <1585656658-1838-2-git-send-email-ego@linux.vnet.ibm.com>
In-Reply-To: <1585656658-1838-2-git-send-email-ego@linux.vnet.ibm.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Message-Id: <1585880035.5ddwqv4syr.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Gautham R. Shenoy's on March 31, 2020 10:10 pm:
> From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
>=20
> If a guest executes a stop instruction when the hypervisor has set the
> PSSCR[ESL|EC] bits, the processor will throw an Hypervisor Facility
> Unavailable exception. Currently when we receive this exception, we
> only check if the exeception is generated due to a doorbell
> instruction, in which case we emulate it. For all other cases,
> including the case when the guest executes a stop-instruction, the
> hypervisor sends a PROGILL to the guest program, which results in a
> guest crash.
>=20
> This patch adds code to handle the case when the hypervisor receives a
> H_FAC_UNAVAIL exception due to guest executing the stop
> instruction. The hypervisor increments the pc to the next instruction
> and resumes the guest as expected by the semantics of the
> PSSCR[ESL|EC] =3D 0 stop instruction.

This seems reasonable, I don't think we need to crash the guest here.

Thanks,
Nick
=
