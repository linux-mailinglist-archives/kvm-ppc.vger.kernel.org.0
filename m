Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FA656C8EB
	for <lists+kvm-ppc@lfdr.de>; Sat,  9 Jul 2022 12:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGIKSL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 9 Jul 2022 06:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGIKSJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 9 Jul 2022 06:18:09 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725BF3CBF2
        for <kvm-ppc@vger.kernel.org>; Sat,  9 Jul 2022 03:18:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lg5gy4bRQz4xv5;
        Sat,  9 Jul 2022 20:18:06 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
Cc:     npiggin@gmail.com, kvm-ppc@vger.kernel.org
In-Reply-To: <20220525130554.2614394-1-farosas@linux.ibm.com>
References: <20220525130554.2614394-1-farosas@linux.ibm.com>
Subject: Re: [PATCH 0/5] KVM: PPC: Book3S HV: Update debug timing code
Message-Id: <165736166828.12236.1106310523445235191.b4-ty@ellerman.id.au>
Date:   Sat, 09 Jul 2022 20:14:28 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 25 May 2022 10:05:49 -0300, Fabiano Rosas wrote:
> We have some debug information at /sys/kernel/debug/kvm/<vm>/vcpu#/timings
> which shows the time it takes to run various parts of the code.
> 
> That infrastructure was written in the P8 timeframe and wasn't updated
> along with the guest entry point changes for P9.
> 
> Ideally we would be able to just add new/different accounting points
> to the code as it changes over time but since the P8 and P9 entry
> points are different code paths we first need to separate them from
> each other. This series alters KVM Kconfig to make that distinction.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/5] KVM: PPC: Book3S HV: Fix "rm_exit" entry in debugfs timings
      https://git.kernel.org/powerpc/c/9981bace85d816ed8724ac46e49285e8488d29e6
[2/5] KVM: PPC: Book3S HV: Add a new config for P8 debug timing
      https://git.kernel.org/powerpc/c/3f8ed993be3cf154a91d9ab5e80470c6c755adbe
[3/5] KVM: PPC: Book3S HV: Decouple the debug timing from the P8 entry path
      https://git.kernel.org/powerpc/c/c3fa64c99c61d99631a8e06a6cf991c35c98ec7d
[4/5] KVM: PPC: Book3S HV: Expose timing functions to module code
      https://git.kernel.org/powerpc/c/2861c827286fb6646f6b6caee418efd99992097c
[5/5] KVM: PPC: Book3S HV: Provide more detailed timings for P9 entry path
      https://git.kernel.org/powerpc/c/b44bb1b7cbbae66ec73868f5fbd57c54f0612d1c

cheers
