Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75A84B8864
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Feb 2022 14:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiBPNFE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Feb 2022 08:05:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiBPNFE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 16 Feb 2022 08:05:04 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B20226120A
        for <kvm-ppc@vger.kernel.org>; Wed, 16 Feb 2022 05:04:51 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JzJ8J0lWNz4xPt;
        Thu, 17 Feb 2022 00:04:48 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     kvm-ppc@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>
Cc:     npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org, aik@ozlabs.ru
In-Reply-To: <20220125215655.1026224-1-farosas@linux.ibm.com>
References: <20220125215655.1026224-1-farosas@linux.ibm.com>
Subject: Re: [PATCH v5 0/5] KVM: PPC: MMIO fixes
Message-Id: <164501666777.530536.8902205989828226400.b4-ty@ellerman.id.au>
Date:   Thu, 17 Feb 2022 00:04:27 +1100
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

On Tue, 25 Jan 2022 18:56:50 -0300, Fabiano Rosas wrote:
> Changes from v4:
> 
> -patch 4: switched to kvm_debug_ratelimited.
> 
> -patch 5: kept the Program interrupt for BookE.
> 
> v4:
> https://lore.kernel.org/r/20220121222626.972495-1-farosas@linux.ibm.com
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/5] KVM: PPC: Book3S HV: Stop returning internal values to userspace
      https://git.kernel.org/powerpc/c/36d014d37d59065087e51b8381e37993f1ca99bc
[2/5] KVM: PPC: Fix vmx/vsx mixup in mmio emulation
      https://git.kernel.org/powerpc/c/b99234b918c6e36b9aa0a5b2981e86b6bd11f8e2
[3/5] KVM: PPC: mmio: Reject instructions that access more than mmio.data size
      https://git.kernel.org/powerpc/c/3f831504482ab0d0d53d1966987959d1485345cc
[4/5] KVM: PPC: mmio: Return to guest after emulation failure
      https://git.kernel.org/powerpc/c/349fbfe9b918e6dea00734f07c0fbaf4c2e2df5e
[5/5] KVM: PPC: Book3s: mmio: Deliver DSI after emulation failure
      https://git.kernel.org/powerpc/c/c1c8a66367a35aabbad9bd629b105b9fb49f2c1f

cheers
