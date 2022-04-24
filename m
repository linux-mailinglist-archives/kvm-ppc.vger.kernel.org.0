Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3551C50D1A8
	for <lists+kvm-ppc@lfdr.de>; Sun, 24 Apr 2022 14:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiDXMTK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 24 Apr 2022 08:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiDXMTJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 24 Apr 2022 08:19:09 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFAA3B2A9
        for <kvm-ppc@vger.kernel.org>; Sun, 24 Apr 2022 05:16:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KmRv70kBDz4xXk;
        Sun, 24 Apr 2022 22:16:03 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
In-Reply-To: <20220420050840.328223-1-aik@ozlabs.ru>
References: <20220420050840.328223-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel v2] KVM: PPC: Fix TCE handling for VFIO
Message-Id: <165080252010.1540533.16052214523820715749.b4-ty@ellerman.id.au>
Date:   Sun, 24 Apr 2022 22:15:20 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 20 Apr 2022 15:08:40 +1000, Alexey Kardashevskiy wrote:
> The LoPAPR spec defines a guest visible IOMMU with a variable page size.
> Currently QEMU advertises 4K, 64K, 2M, 16MB pages, a Linux VM picks
> the biggest (16MB). In the case of a passed though PCI device, there is
> a hardware IOMMU which does not support all pages sizes from the above -
> P8 cannot do 2MB and P9 cannot do 16MB. So for each emulated
> 16M IOMMU page we may create several smaller mappings ("TCEs") in
> the hardware IOMMU.
> 
> [...]

Applied to powerpc/fixes.

[1/1] KVM: PPC: Fix TCE handling for VFIO
      https://git.kernel.org/powerpc/c/26a62b750a4e6364b0393562f66759b1494c3a01

cheers
