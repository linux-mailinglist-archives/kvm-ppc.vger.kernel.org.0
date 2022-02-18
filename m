Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781BF4BAF6E
	for <lists+kvm-ppc@lfdr.de>; Fri, 18 Feb 2022 03:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiBRCKd (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 17 Feb 2022 21:10:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiBRCKb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 17 Feb 2022 21:10:31 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F8410DC
        for <kvm-ppc@vger.kernel.org>; Thu, 17 Feb 2022 18:10:16 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K0FX275nZz4xZq;
        Fri, 18 Feb 2022 13:10:10 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     kvm-ppc@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com
In-Reply-To: <20211223211931.3560887-1-farosas@linux.ibm.com>
References: <20211223211931.3560887-1-farosas@linux.ibm.com>
Subject: Re: [PATCH 0/3] KVM: PPC: KVM module exit fixes
Message-Id: <164515018870.908917.9938379332717463951.b4-ty@ellerman.id.au>
Date:   Fri, 18 Feb 2022 13:09:48 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 23 Dec 2021 18:19:28 -0300, Fabiano Rosas wrote:
> This is a resend the module cleanup fixes but this time without the
> HV/PR merge.
> 
> Fabiano Rosas (1):
>   KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
>   KVM: PPC: Book3S HV: Delay setting of kvm ops
>   KVM: PPC: Book3S HV: Free allocated memory if module init fails
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/3] KVM: PPC: Book3S HV: Check return value of kvmppc_radix_init
      https://git.kernel.org/powerpc/c/69ab6ac380a00244575de02c406dcb9491bf3368
[2/3] KVM: PPC: Book3S HV: Delay setting of kvm ops
      https://git.kernel.org/powerpc/c/c5d0d77b45265905bba2ce6e63c9a02bbd11c43c
[3/3] KVM: PPC: Book3S HV: Free allocated memory if module init fails
      https://git.kernel.org/powerpc/c/175be7e5800e2782a7e38ee9e1b64633494c4b44

cheers
