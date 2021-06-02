Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E1C398859
	for <lists+kvm-ppc@lfdr.de>; Wed,  2 Jun 2021 13:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhFBL2t (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 2 Jun 2021 07:28:49 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:28822 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbhFBL2a (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 2 Jun 2021 07:28:30 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622633197; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=qKWL67xEH4Fs/7G/O+5jYXPRzXQtmoiQvDQiLXUBwS4d2taCcU86oDAsDtANifW0+P
    w6xb3TQueUu8w8Df/WYvZLBJX1miANGtgbglWElomLPQxwFRWJvZxTivV6yyMHZwEIuv
    v2M76pspPHjDAA0Y89/JNbtokMnb1GZa8OocgOc0Kw/toMJosgM0zpk2fPp0OjgyPkeW
    kwo/WNci4rul+wrrjy5mR1SyqT2YYfB6aXH65WkXuTIah98w3pdRmFJXnkBi4+5NC26/
    s6e9rLCH9M3/ydy8/04aWwOTVyG1+UJgbKV0FSE8wBw6Mk9gbN6cxJvWXglaBRxFblQ1
    7lQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622633197;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=jB6LHubYTK9MHDb6zr9KaVILv3xD3DGRVwdD6lXExXU=;
    b=KLowtl7xiCKb1hDcmeFa2qWL+gZHlt3udoohMsbrCy4oRK15xBR4bWQyYyuGGp1/ul
    Fz0p7yoZZQrZNWeoaJwnbDT6N+k7tsnhchiCV1maUd99+rt0f81hWyWQk0ev6CFbfKKq
    Nd5bwGYFXh9SBWMLEmM+DF6/e9e4+gIQ2rZxp15tGorC33zRmL19N9igV+TiN+JbRzVA
    b2WXxcoLvx1/tBDOyNkAXAJK2HUpMAZNXKuFWhkYu5G0y+AdJxoKx5H7WnglKXKZu2UX
    oDPwre+04Qt+AzAOilcPiFq+vgRgzi0wZxt+JQF0zhZQNLGhMXT2Hc6uilPpJA8jUgZQ
    mJ3w==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622633197;
    s=strato-dkim-0002; d=xenosoft.de;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=jB6LHubYTK9MHDb6zr9KaVILv3xD3DGRVwdD6lXExXU=;
    b=KrxTDsXnAC4iFk9oplz3l9L8vIjXT+I0MqZhR+0yas47+BI+yOhdOv24zvVGNBO2I7
    hyEIg8g43sEm8/VOJIxC2HcHrGu7+3xtZ0K2upMwYH9FD/EtOl+Pq+ZLhJkTP7oAzhBT
    hQ1oenmo/WMQ2Ig1fhgck2rM3nfKsaP1EH5f5ziScDn/C77kQNQkzChubxfHAvJmDmbv
    Kff1lqPeYThv7A90yb3srOeuKCeYw0pqmGFXf7+LJyhbzYZZ6VT59vn8S/4WgBnky55R
    v32itJDUYAVKBUARrHpQZakK9tIsoMOZKdjyidkH6o3b6zvTmUTdm/14xxtkI8KGoxgf
    PLnw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPgBLnq1lFHSB+0Wnf9zTVpJV4NjwA=="
X-RZG-CLASS-ID: mo00
Received: from Christians-iMac.fritz.box
    by smtp.strato.de (RZmta 47.27.2 AUTH)
    with ESMTPSA id g069fax52BQZ202
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 2 Jun 2021 13:26:35 +0200 (CEST)
Subject: Re: [FSL P50x0] KVM HV doesn't work anymore
To:     Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Darren Stevens <darren@stevens-zone.net>,
        Christian Zigotzky <info@xenosoft.de>,
        mad skateman <madskateman@gmail.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>
References: <04526309-4653-3349-b6de-e7640c2258d6@xenosoft.de>
 <34617b1b-e213-668b-05f6-6fce7b549bf0@xenosoft.de>
 <9af2c1c9-2caf-120b-2f97-c7722274eee3@csgroup.eu>
 <199da427-9511-34fe-1a9e-08e24995ea85@xenosoft.de>
 <1621236734.xfc1uw04eb.astroid@bobo.none>
 <e6ed7674-3df9-ec3e-8bcf-dcd8ff0fecf8@xenosoft.de>
 <1621410977.cgh0d6nvlo.astroid@bobo.none>
 <acf63821-2030-90fa-f178-b2baeb0c4784@xenosoft.de>
 <1621464963.g8v9ejlhyh.astroid@bobo.none>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <f437d727-8bc7-6467-6134-4e84942628f1@xenosoft.de>
Date:   Wed, 2 Jun 2021 13:26:35 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1621464963.g8v9ejlhyh.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 20 May 2021 at 01:07am, Nicholas Piggin wrote:
> Hmm, okay that probably rules out those notifier changes then.
> Can you remind me were you able to rule these out as suspects?
>
> 8f6cc75a97d1 powerpc: move norestart trap flag to bit 0
> 8dc7f0229b78 powerpc: remove partial register save logic
> c45ba4f44f6b powerpc: clean up do_page_fault
> d738ee8d56de powerpc/64e/interrupt: handle bad_page_fault in C
> ceff77efa4f8 powerpc/64e/interrupt: Use new interrupt context tracking scheme
> 097157e16cf8 powerpc/64e/interrupt: reconcile irq soft-mask state in C
> 3db8aa10de9a powerpc/64e/interrupt: NMI save irq soft-mask state in C
> 0c2472de23ae powerpc/64e/interrupt: use new interrupt return
> dc6231821a14 powerpc/interrupt: update common interrupt code for
> 4228b2c3d20e powerpc/64e/interrupt: always save nvgprs on interrupt
> 5a5a893c4ad8 powerpc/syscall: switch user_exit_irqoff and trace_hardirqs_off order
>
> Thanks,
> Nick
Hi Nick,

I tested these commits above today and all works with -smp 4. [1]

Smp 4 still doesn't work with the RC4 of kernel 5.13 on quad core e5500 
CPUs with KVM HV. I use -smp 3 currently.

What shall I test next?

Thanks,
Christian

[1] https://forum.hyperion-entertainment.com/viewtopic.php?p=53367#p53367
