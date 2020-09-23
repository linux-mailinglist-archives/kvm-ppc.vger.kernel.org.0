Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C14E274DAF
	for <lists+kvm-ppc@lfdr.de>; Wed, 23 Sep 2020 02:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgIWAL2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Sep 2020 20:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgIWAL1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Sep 2020 20:11:27 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27BFC061755;
        Tue, 22 Sep 2020 17:11:27 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Bwz9m2YXVz9sTS; Wed, 23 Sep 2020 10:11:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1600819884; bh=G+N3yoVOI9E8o3gp3+ye5hXZh0Mpi9UiooyzPlfEfIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pg5/vc5QVcKPX6kMXt5hXEMpr8+byLdCFxI04s1KLynA2TTkSOnWN2brWIgQ7g/th
         3dv3j362BM9ADcvHuL0LVDlVx/qw//O+dv7KKYynsZhrhkv7oxVzg1jtVSVSOvjlRg
         41Hw/D0p66YLV+mVPuGBEq6ICWZarSxwPduzp7m4192Tuj0BkAMnmvDgT+kHov+7BJ
         HnPJe2YrUZooVMJV/oPZEgyfvZXzOMiJxha/MYlrls1zTL+jwsVaWrQw2PV+NrNKif
         rXMWddkQaBymNHcag8s2QSH+rHn1b1SyGMnMUyCfTqfSZGZGz4qH4gB38wzrNYxNpz
         1itAeN1Jrnlgg==
Date:   Wed, 23 Sep 2020 10:09:05 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] KVM: PPC: Book3S HV: XIVE: Convert to
 DEFINE_SHOW_ATTRIBUTE
Message-ID: <20200923000905.GD531519@thinks.paulus.ozlabs.org>
References: <20200919012925.174377-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919012925.174377-1-miaoqinglang@huawei.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Sep 19, 2020 at 09:29:25AM +0800, Qinglang Miao wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Thanks, applied.

Paul.
