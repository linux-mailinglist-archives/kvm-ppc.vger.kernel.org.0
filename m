Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52CAB4DAC15
	for <lists+kvm-ppc@lfdr.de>; Wed, 16 Mar 2022 08:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354350AbiCPHzE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 16 Mar 2022 03:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354224AbiCPHzE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 16 Mar 2022 03:55:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23C4460CE7
        for <kvm-ppc@vger.kernel.org>; Wed, 16 Mar 2022 00:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647417229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xbrJE+kT+A4TgNq8to760TzvdzqcyJdX7Cp/jTz5ddk=;
        b=XugeXJ7Eus/5iy1hfbiMcEoIEXCkmqdo1nM5R6fxUkNJOgO/tqeh6nU58s21yLm0sLqu33
        wBmuu870yMRwQN4fX1IQ3boA70wcc39B+n8bIJU60vjIzwCFLUtzaXMnUATRJt5CScL82a
        Czrv1Zd0QS14HxXDaaIx8oFLU5RmRdU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-k4Bm7EgWPrWs5mLnm76ODA-1; Wed, 16 Mar 2022 03:53:47 -0400
X-MC-Unique: k4Bm7EgWPrWs5mLnm76ODA-1
Received: by mail-wr1-f72.google.com with SMTP id t15-20020adfdc0f000000b001ef93643476so271580wri.2
        for <kvm-ppc@vger.kernel.org>; Wed, 16 Mar 2022 00:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xbrJE+kT+A4TgNq8to760TzvdzqcyJdX7Cp/jTz5ddk=;
        b=JdwPGhFh9oLQ0+YBz1MdWxCruH0CFzht1L+ZBPcssV64A03l0hMMWnVlb97ZNpEZiU
         5aS4R4ar4s7scRwmLSZWmr0UM5nNi3C/T6ZvbQOBcURUsBz7nqwct1kMFy2IjOkwYINw
         +x3V0RBq7dbIclGrW55sI2KBFa4YFG7QyE3PHZZHoZ2qggewoIMSRqDWZn1TqHSp8Uw/
         /Y3srt5x3uDu9l0UC3aB0onEOq3klRjI5l1Hc6m2DxOgHlcQrNEE7C28qdeuvd18QJ/0
         r/sjgsccuu7niRzPcUcTKxQTDytKZxHAwy9ryIQm+pBrQazhp7kxywg2nYpRMjQ0jkvw
         BJIA==
X-Gm-Message-State: AOAM532HPL1AYd1mTKLpy8A3aXejwhLcZXvt8OCqmCMuIxfQHNJAMIDx
        HN0ICKmloLpGuOMIdUt1QOzO6P4y39OqkxGRdYI2guOxLmOg/izmbLjKFSOqdP5Iyz0knqbYUs3
        1Ls6lGoU2AW04L+INQA==
X-Received: by 2002:a1c:4c13:0:b0:389:a4ab:df7c with SMTP id z19-20020a1c4c13000000b00389a4abdf7cmr6206713wmf.14.1647417226810;
        Wed, 16 Mar 2022 00:53:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+ih92S8u3acUVacRNC38Qj2+u/ewT64E9VVLdgOqn7mbnYPyPFAiPxKeeFBjt2DWcwzIGBA==
X-Received: by 2002:a1c:4c13:0:b0:389:a4ab:df7c with SMTP id z19-20020a1c4c13000000b00389a4abdf7cmr6206704wmf.14.1647417226551;
        Wed, 16 Mar 2022 00:53:46 -0700 (PDT)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k18-20020a5d6d52000000b00203da94cf01sm982259wri.14.2022.03.16.00.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 00:53:46 -0700 (PDT)
Message-ID: <334cc93e-9843-daa9-5846-394c199e294f@redhat.com>
Date:   Wed, 16 Mar 2022 08:53:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH] libfdt: use logical "or" instead of
 bitwise "or" with boolean operands
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        lvivier@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220316060214.2200695-1-morbo@google.com>
 <20220316074356.n7e5lzrmnal2dcgu@gator>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220316074356.n7e5lzrmnal2dcgu@gator>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 16/03/2022 08.43, Andrew Jones wrote:
> On Tue, Mar 15, 2022 at 11:02:14PM -0700, Bill Wendling wrote:
>> Clang warns about using a bitwise '|' with boolean operands. This seems
>> to be due to a small typo.
>>
>>    lib/libfdt/fdt_rw.c:438:6: warning: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>>            if (can_assume(LIBFDT_ORDER) |
>>
>> Using '||' removes this warnings.
>>
>> Signed-off-by: Bill Wendling <morbo@google.com>
>> ---
>>   lib/libfdt/fdt_rw.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/libfdt/fdt_rw.c b/lib/libfdt/fdt_rw.c
>> index 13854253ff86..3320e5559cac 100644
>> --- a/lib/libfdt/fdt_rw.c
>> +++ b/lib/libfdt/fdt_rw.c
>> @@ -435,7 +435,7 @@ int fdt_open_into(const void *fdt, void *buf, int bufsize)
>>   			return struct_size;
>>   	}
>>   
>> -	if (can_assume(LIBFDT_ORDER) |
>> +	if (can_assume(LIBFDT_ORDER) ||
>>   	    !fdt_blocks_misordered_(fdt, mem_rsv_size, struct_size)) {
>>   		/* no further work necessary */
>>   		err = fdt_move(fdt, buf, bufsize);
>> -- 
>> 2.35.1.723.g4982287a31-goog
>>
> 
> This is fixed in libfdt upstream with commit 7be250b4 ("libfdt:
> Correct condition for reordering blocks"), which is in v1.6.1.
> We can either take this patch as a backport of 7be250b4 or we
> can rebase all of our libfdt to v1.6.1. Based on the number of
> fixes in v1.6.1, which appear to be mostly for compiling with
> later compilers, I'm in favor of rebasing.

+1 for updating to v1.6.1 completely.

> Actually, we can also use this opportunity to [re]visit the
> idea of changing libfdt to a git submodule. I'd like to hear
> opinions on that.

I'm always a little bit torn when it comes to this question. Sure, git 
submodules maybe make the update easier ... but they are a real pita when 
you're working with remote machines that might not have direct connection to 
the internet. For example, I'm used to rsync my sources to the non-x86 
machines, and if you forget to update the submodule to the right state 
before the sync, you've just lost. So from my side, it's a preference for 
continuing without submodules (but I won't insist if everybody else wants to 
have them instead).

  Thomas

