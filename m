Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B173564A2
	for <lists+kvm-ppc@lfdr.de>; Wed,  7 Apr 2021 08:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhDGG6G (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 7 Apr 2021 02:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbhDGG6F (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 7 Apr 2021 02:58:05 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF428C06174A
        for <kvm-ppc@vger.kernel.org>; Tue,  6 Apr 2021 23:57:56 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4FFZwK5Qprz9sWK; Wed,  7 Apr 2021 16:57:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617778673; bh=z6W65AtEdnkKNrWxgWMigIVD5t03SwC5KdJI00urOnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hg6x7wJdAA6UnpbEA9B76JaoUoXNQw9UoMp5LjtPK//6c3Q1u6hmxhdte/IQxhyX2
         1k09MXAN7yimulZdtvdBdEuo4HDEku06l22dYt4kmWMhv2yvWx7KA5Ebr/fwK16k8L
         aB0cEM+x57RF7LujLZ/dmAY1VujS5SD2r+J9Y0X9Md0QF4SMiSXySKDHiAq4wq9LVp
         D/dyBhlgL78shJmLlZKWns3z+7kWvgGDpVhO6r3lGFxewutmkKKVC38DxB5wzO3S93
         SNTU13vmRAL1xae1R8g7o3097JKe7yN6g5jO0E80zX03jDeEidDHsjXD1ySk3hNom+
         EEsj6o5UJrpiQ==
Date:   Wed, 7 Apr 2021 16:51:30 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 38/48] KVM: PPC: Book3S HV: Remove support for
 dependent threads mode on P9
Message-ID: <YG1WcjXTbGtsqHgY@thinks.paulus.ozlabs.org>
References: <20210405011948.675354-1-npiggin@gmail.com>
 <20210405011948.675354-39-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405011948.675354-39-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Apr 05, 2021 at 11:19:38AM +1000, Nicholas Piggin wrote:
> Radix guest support will be removed from the P7/8 path, so disallow
> dependent threads mode on P9.

Dependent threads mode on P9 was added in order to support the mode
where for security reasons you want to restrict the vcpus that run on
a core to all be from the same VM, without requiring all guests to run
single-threaded.  This was (at least at one stage) thought to be a
useful mode for users that are worried about side-channel data leaks.

Now it's possible that that mode is not practically useful for some
reason, or that no-one actually wants it, but its removal should be
discussed.  Also, the fact that we are losing that mode should be
explicit in the commit message.

Paul.
