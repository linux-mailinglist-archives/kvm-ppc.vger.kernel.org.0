Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B182FAF1A
	for <lists+kvm-ppc@lfdr.de>; Tue, 19 Jan 2021 04:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394898AbhASD2P (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 18 Jan 2021 22:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387937AbhASD2F (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 18 Jan 2021 22:28:05 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4FEC061573
        for <kvm-ppc@vger.kernel.org>; Mon, 18 Jan 2021 19:27:21 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id i7so12169207pgc.8
        for <kvm-ppc@vger.kernel.org>; Mon, 18 Jan 2021 19:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=IvOBsG72TdtWfS2ELjW2ZROhGBBtphs2og0NRX6347g=;
        b=WzlPZUCPM1Cpmyg5zbkdCabBVvDTpgo8HeopahJpAXcJuBQctVehr4fdJ7m2jOoTt+
         vkFbB+v/gPYeVUQo7bAffL3xndtPaPwPxhtT8hzJcxSYC5PU71DcbGJxuNbOM+XdHcLK
         L75NUaoLyUSyKV0k2c27k1iIhCjoSDuHgDsbDaIIP6BYY0pu/lPJnhutPEMwsBOMZvjm
         OvkLMroUT/L2C3UQJJIyRJjVCiA4iXPN4O6Gz5OVVYBrbSMIhdbgRxvyG4lehy2x7iEO
         llE/soVjr3po/L0NOpvUEKcKpsMDVUL/d/HQj5NmbyyOUlOYGKjduvccvEfuGATDBKVY
         JnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=IvOBsG72TdtWfS2ELjW2ZROhGBBtphs2og0NRX6347g=;
        b=WSPHZP+JF4j2ZFjY7YfTjEd4bxysXz1ykIJW1lDZovFKfSAGYG7dwOK0YdMPT5vc8g
         ylC2vYpd5cVAViVz5KxKcloPwiGQ4PPLR6FdtgqAp66vq5vUZGjp/zPrMPXvXTS6FEzO
         BxmPiv1bQnBbcla6hJswlHDTs3Z7Oscwqq5/CikceYcOl3iiCi5VqLCHfHkB6j20l4M6
         pKCSDtgNVWEXB9u1mrkiqqCYec8UrdgCl2cr+o6ho35OMea7Z48O1TrBeNxhqLnIGJd6
         rsLpeYK0UCmgwagbvoSXXHrCF85jUjDdRDevTeZIw2gVRsKimxy5yAXKij1ya//7nwcq
         rpgg==
X-Gm-Message-State: AOAM531KeaVV6bRWfJ8OHwlIQE9B1Td2fBsYxW9bLmSRVZ6RwVe1fvuq
        72X1fS8Cx9Pute4a5TdIYimsrns1gZU=
X-Google-Smtp-Source: ABdhPJx3qm+cpo9wollUnAI7zsT1q9W49I+QP8XB1qmGNZRU8jW7AlePuZqpCb/i2a/qtXU0ANS1HA==
X-Received: by 2002:a63:4e44:: with SMTP id o4mr2666091pgl.46.1611026840999;
        Mon, 18 Jan 2021 19:27:20 -0800 (PST)
Received: from localhost ([124.170.13.62])
        by smtp.gmail.com with ESMTPSA id b72sm16882132pfb.129.2021.01.18.19.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 19:27:20 -0800 (PST)
Date:   Tue, 19 Jan 2021 13:27:15 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 1/4] KVM: PPC: Book3S HV: Remove support for running HPT
 guest on RPT host without mixed mode support
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
References: <20210118062809.1430920-1-npiggin@gmail.com>
        <20210118062809.1430920-2-npiggin@gmail.com> <87czy1bsvz.fsf@linux.ibm.com>
In-Reply-To: <87czy1bsvz.fsf@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1611025782.s66bkxjtqz.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Excerpts from Fabiano Rosas's message of January 19, 2021 11:46 am:
> Resending because the previous got spam-filtered:
>=20
> Nicholas Piggin <npiggin@gmail.com> writes:
>=20
>> This reverts much of commit c01015091a770 ("KVM: PPC: Book3S HV: Run HPT
>> guests on POWER9 radix hosts"), which was required to run HPT guests on
>> RPT hosts on early POWER9 CPUs without support for "mixed mode", which
>> meant the host could not run with MMU on while guests were running.
>>
>> This code has some corner case bugs, e.g., when the guest hits a machine
>> check or HMI the primary locks up waiting for secondaries to switch LPCR
>> to host, which they never do. This could all be fixed in software, but
>> most CPUs in production have mixed mode support, and those that don't
>> are believed to be all in installations that don't use this capability.
>> So simplify things and remove support.
>=20
> With this patch in a DD2.1 machine + indep_threads_mode=3DN +
> disable_radix, QEMU aborts and dumps registers, is that intended?

Yes. That configuration is hanging handling MCEs in the guest with some=20
threads waiting forever to synchronize. Paul suggested it was never a
supported configuration so we might just remove it.

> Could we use the 'no_mixing_hpt_and_radix' logic in check_extension to
> advertise only KVM_CAP_PPC_MMU_RADIX to the guest via OV5 so it doesn't
> try to run hash?
>=20
> For instance, if I hack QEMU's 'spapr_dt_ov5_platform_support' from
> OV5_MMU_BOTH to OV5_MMU_RADIX_300 then it boots succesfuly, but the
> guest turns into radix, due to this code in prom_init:
>=20
> prom_parse_mmu_model:
>=20
> case OV5_FEAT(OV5_MMU_RADIX): /* Only Radix */
> 	prom_debug("MMU - radix only\n");
> 	if (prom_radix_disable) {
> 		/*
> 		 * If we __have__ to do radix, we're better off ignoring
> 		 * the command line rather than not booting.
> 		 */
> 		prom_printf("WARNING: Ignoring cmdline option disable_radix\n");
> 	}
> 	support->radix_mmu =3D true;
> 	break;
>=20
> It seems we could explicitly say that the host does not support hash and
> that would align with the above code.

I'm not sure, sounds like you could, on the other hand these aborts seem=20
like the prefered failure mode for these kinds of configuration issues,=20
I don't know what the policy is, is reverting back to radix acceptable?

Thanks,
Nick

