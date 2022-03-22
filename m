Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D134E3FC5
	for <lists+kvm-ppc@lfdr.de>; Tue, 22 Mar 2022 14:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiCVNqK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Mar 2022 09:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiCVNqJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Mar 2022 09:46:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24B632612F
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Mar 2022 06:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647956681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ANKRQzRELaWdzD2QZS9qzovKRV7eroomvX7D4M7GefI=;
        b=g7+V3JbVs1NjAcpGgaxm0/Cgbl4uHRS89TIIyZS3Cp0FZ91N1661wzHpDz6JJmD31Ei6e8
        /cPQiPCqqlGXqOBfTuXue6M1SAVpY+Cd+5uhIL+S1JfjttYivA2cujSNtsqofdB2whZ8Kh
        rDHrp/vvBuu/AJJS8VvFrLCEhhLWAhs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-JzP86nxWPL-fIpVfBqNcWQ-1; Tue, 22 Mar 2022 09:44:40 -0400
X-MC-Unique: JzP86nxWPL-fIpVfBqNcWQ-1
Received: by mail-wm1-f69.google.com with SMTP id c126-20020a1c3584000000b00380dee8a62cso6910293wma.8
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Mar 2022 06:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ANKRQzRELaWdzD2QZS9qzovKRV7eroomvX7D4M7GefI=;
        b=LIdzcMaSzO/THY4l+5W7ahWuLQwG5PV8VWYKFR/OhhIO1JYs6pZagqblS4omx16hpU
         GZzQYSLbNriToQ7paCdPfOe01D0+ZvhXM/vsx4w58a0HM/MStauoefTCXaVJwWgro28y
         JMMhjFa4Gp0IIO2dijL5e0Vh33v857VFPTEBbVlwWHVxKMTEkSjyAhTBmCPRFnCvw9uU
         bsVBCfHMJCurbBYBzvYTU7ZJ1G9kFT3952PZFb0EuactVmguOA+JP88MLzJS0fkPh9fW
         k9Ir4bLp9vNNsLScP86TCwQh0gwnJwGL6RbHdS5CNv7spiV92F+oBQN7/0k97i38JbKU
         9KHQ==
X-Gm-Message-State: AOAM531Ut6QcBBYq6ucQ8qW8NrQN8IuLbDu3f034wQ5HVNTFxI5c3kwb
        OHz83XBQJIsqYwLnPFLlJNtTi0YiU4T+XTK2LsMAK49AMzXn5Y0CyMjEafOSXK3YxJ6Xn+F/H+p
        IeKWqzIc61GMslZ5TiA==
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id j14-20020a05600c190e00b0038cb1eaf4acmr3938605wmq.70.1647956678927;
        Tue, 22 Mar 2022 06:44:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKzYLnUW0xmdSIOPKaXoGHiETfm21cVrTbD3uRC5iXSe1fa2PPvEzTtyV8TFh7MPCRVt9NLQ==
X-Received: by 2002:a05:600c:190e:b0:38c:b1ea:f4ac with SMTP id j14-20020a05600c190e00b0038cb1eaf4acmr3938572wmq.70.1647956678543;
        Tue, 22 Mar 2022 06:44:38 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id e8-20020a056000178800b00203da3bb4d2sm16782777wrg.41.2022.03.22.06.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 06:44:37 -0700 (PDT)
Message-ID: <da339883-fc3a-da42-a071-d6e6c9f88b3e@redhat.com>
Date:   Tue, 22 Mar 2022 14:44:36 +0100
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
        linux-s390@vger.kernel.org, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com
References: <20220316060214.2200695-1-morbo@google.com>
 <20220318093601.zqhuzrp2ujgswsiw@gator>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220318093601.zqhuzrp2ujgswsiw@gator>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 18/03/2022 10.36, Andrew Jones wrote:
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
> We're not getting as much interest in the submodule discussion as I hoped.
> I see one vote against on this thread and one vote for on a different
> thread[1]. For now I'll just commit a big rebase patch for libfdt. We can
> revisit it again after we decide what to do for QCBOR.

I recently learnt that there are indeed people who ship kvm-unit-tests with 
their distro - at least buildroot has a package:
https://git.busybox.net/buildroot/tree/package/kvm-unit-tests

So one more argument for copying the files over instead of using submodules: 
The tarballs for tags will be self-contained, e.g.:

https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/archive/v2022-03-08/kvm-unit-tests-v2022-03-08.tar.gz

If we use submodules, I guess the content of the submodule content will be 
missing in there?

  Thomas

